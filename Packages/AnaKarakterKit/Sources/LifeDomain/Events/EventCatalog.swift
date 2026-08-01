/// Tip güvenli olay kataloğu: olay listesi + karakter havuzları.
/// İçerik `LifeContent` hedefinde yaşar; şema doğrulaması ContentLint'te.
public struct EventCatalog: Sendable, Equatable {
    public let events: [LifeEvent]
    public let pools: PersonPools

    private let byID: [EventID: LifeEvent]
    private let milestonesByAge: [Int: [LifeEvent]]
    private let poolBySeason: [Season: [LifeEvent]]

    public init(events: [LifeEvent], pools: PersonPools) {
        self.events = events
        self.pools = pools

        var byID: [EventID: LifeEvent] = [:]
        var milestonesByAge: [Int: [LifeEvent]] = [:]
        var poolBySeason: [Season: [LifeEvent]] = [:]
        for event in events {
            byID[event.id] = event
            switch event.trigger {
            case let .milestone(age):
                milestonesByAge[age, default: []].append(event)
            case let .pool(seasons):
                for season in seasons {
                    poolBySeason[season, default: []].append(event)
                }
            case .followUpOnly:
                break
            }
        }
        self.byID = byID
        self.milestonesByAge = milestonesByAge
        self.poolBySeason = poolBySeason
    }

    public func event(id: EventID) -> LifeEvent? {
        byID[id]
    }

    /// Bu yaşın kilometre taşları — katalogdaki bildirim sırasıyla (deterministik).
    public func milestones(forAge age: Int) -> [LifeEvent] {
        milestonesByAge[age] ?? []
    }

    public func poolEvents(season: Season) -> [LifeEvent] {
        poolBySeason[season] ?? []
    }
}
