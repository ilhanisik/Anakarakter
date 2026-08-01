/// Yılın olay destesi: koşul süzgeci + ağırlıklı seed'li çekiliş + soğuma kuralı.
enum EventDeck {
    /// Bir olayın bu yaşta tekrar tetiklenebilirliği (soğuma kuralı).
    static func cooldownAllows(_ event: LifeEvent, state: LifeState) -> Bool {
        guard let lastAge = state.lastOccurrenceAge[event.id] else { return true }
        switch event.cooldown {
        case .oncePerLife:
            return false
        case let .years(gap):
            return state.age - lastAge >= gap
        }
    }

    static func isEligible(_ event: LifeEvent, state: LifeState) -> Bool {
        cooldownAllows(event, state: state) && event.conditions.allSatisfied(by: state)
    }

    /// Yılın olay listesini çıkarır. Sıra deterministiktir:
    /// 1) vadesi gelen takip olayları (kuyruk sırasıyla),
    /// 2) yaşın kilometre taşları (katalog sırasıyla),
    /// 3) sezon havuzundan ağırlıklı çekilişler (hedef sayıya tamamlanır).
    static func drawYearEvents(state: inout LifeState, catalog: EventCatalog) -> [LifeEvent] {
        var drawn: [LifeEvent] = []
        var drawnIDs = Set<EventID>()

        // 1) Takip olayları — vadesi gelenler kuyruktan düşer; koşulu
        // sağlamayanlar sessizce atlanır (zincir kırılır, hayat sürer).
        var remainingQueue: [ScheduledFollowUp] = []
        for scheduled in state.followUpQueue {
            if scheduled.dueAge > state.age {
                remainingQueue.append(scheduled)
                continue
            }
            guard let event = catalog.event(id: scheduled.eventID),
                  isEligible(event, state: state),
                  !drawnIDs.contains(event.id)
            else { continue }
            drawn.append(event)
            drawnIDs.insert(event.id)
        }
        state.followUpQueue = remainingQueue

        // 2) Kilometre taşları — garanti omurga.
        for event in catalog.milestones(forAge: state.age)
        where isEligible(event, state: state) && !drawnIDs.contains(event.id) {
            drawn.append(event)
            drawnIDs.insert(event.id)
        }

        // 3) Havuz çekilişi — hedef toplam sayıya tamamla.
        let target = state.rng.int(in: LifeDomain.eventsPerYear)
        var pool = catalog.poolEvents(season: state.season)
            .filter { isEligible($0, state: state) && !drawnIDs.contains($0.id) }
        while drawn.count < target, !pool.isEmpty {
            guard let index = state.rng.weightedIndex(weights: pool.map(\.weight)) else { break }
            let event = pool.remove(at: index)
            drawn.append(event)
            drawnIDs.insert(event.id)
        }

        return drawn
    }
}
