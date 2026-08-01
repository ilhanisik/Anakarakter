import Testing
import LifeDomain
import LifeContent

/// İçerik kapısı: şema + kapsama + içerik çizgisi + denge (docs/02).
/// Her içerik değişikliği bu testlerden geçmeden katalog'a giremez.
@Suite("ContentLint — şema")
struct ContentSchemaLint {
    let events = ContentCatalog.events

    @Test("Olay kimlikleri benzersizdir")
    func uniqueEventIDs() {
        let ids = events.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test("Karar olayları 2–4 seçenekli; en az bir koşulsuz seçenek var")
    func choiceRules() {
        for event in events where event.isDecision {
            #expect((2...4).contains(event.choices.count), "\(event.id.rawValue): seçenek sayısı bantta değil")
            #expect(event.choices.contains { $0.conditions.isEmpty },
                    "\(event.id.rawValue): koşulsuz seçenek yok — çıkmaz karar riski")
            let choiceIDs = event.choices.map(\.id)
            #expect(Set(choiceIDs).count == choiceIDs.count, "\(event.id.rawValue): seçenek kimliği çakışıyor")
        }
    }

    @Test("Her seçenekte en az bir sonuç, her sonuçta pozitif ağırlık")
    func outcomeRules() {
        for event in events {
            for choice in event.choices {
                #expect(!choice.outcomes.isEmpty, "\(event.id.rawValue).\(choice.id.rawValue): sonuç yok")
                for outcome in choice.outcomes {
                    #expect(outcome.weight > 0, "\(event.id.rawValue).\(choice.id.rawValue): ağırlık ≤ 0")
                }
            }
        }
    }

    @Test("Haber olayları etkisiz olamaz")
    func newsHaveEffects() {
        for event in events where !event.isDecision {
            #expect(!event.onOccur.isEmpty, "\(event.id.rawValue): etkisiz haber olayı")
        }
    }

    @Test("Takip hedefleri katalogda; followUpOnly olaylara en az bir zincir çıkıyor")
    func followUpTargets() {
        let ids = Set(events.map(\.id))
        var referenced = Set<EventID>()
        for event in events {
            for choice in event.choices {
                for outcome in choice.outcomes {
                    if let followUp = outcome.followUp {
                        #expect(ids.contains(followUp.eventID),
                                "\(event.id.rawValue): bilinmeyen takip hedefi \(followUp.eventID.rawValue)")
                        #expect(followUp.delayYears >= 1,
                                "\(event.id.rawValue): takip gecikmesi en az 1 yıl olmalı")
                        referenced.insert(followUp.eventID)
                    }
                }
            }
        }
        for event in events where event.trigger == .followUpOnly {
            #expect(referenced.contains(event.id),
                    "\(event.id.rawValue): followUpOnly ama hiçbir zincir işaret etmiyor")
        }
    }

    @Test("Tetik ve soğuma değerleri geçerli")
    func triggerAndCooldown() {
        for event in events {
            #expect(event.weight > 0, "\(event.id.rawValue): ağırlık ≤ 0")
            switch event.trigger {
            case let .milestone(age):
                #expect((0...LifeDomain.maximumAge).contains(age), "\(event.id.rawValue): kilometre taşı yaşı bant dışı")
            case let .pool(seasons):
                #expect(!seasons.isEmpty, "\(event.id.rawValue): sezonu olmayan havuz olayı")
            case .followUpOnly:
                break
            }
            if case let .years(gap) = event.cooldown {
                #expect(gap >= 1, "\(event.id.rawValue): soğuma yılı ≥ 1 olmalı")
            }
        }
    }

    @Test("Koşul ve etkilerdeki bayraklar sözlükte tanımlı")
    func flagsDeclared() {
        func flags(in conditions: [Condition]) -> [LifeFlag] {
            conditions.compactMap {
                switch $0 {
                case let .hasFlag(flag), let .lacksFlag(flag): flag
                default: nil
                }
            }
        }
        func flags(in effects: [Effect]) -> [LifeFlag] {
            effects.compactMap {
                switch $0 {
                case let .setFlag(flag), let .clearFlag(flag): flag
                default: nil
                }
            }
        }
        for event in events {
            var all = flags(in: event.conditions) + flags(in: event.onOccur)
            for choice in event.choices {
                all += flags(in: choice.conditions)
                for outcome in choice.outcomes { all += flags(in: outcome.effects) }
            }
            for flag in all {
                #expect(ContentFlags.all.contains(flag),
                        "\(event.id.rawValue): tanımsız bayrak '\(flag.rawValue)'")
            }
        }
    }
}

@Suite("ContentLint — içerik çizgisi")
struct ContentLineLint {
    let events = ContentCatalog.events

    /// CLAUDE.md İçerik Çizgisi'nden türetilen yasaklı tema kelimeleri.
    static let bannedTerms = [
        "kumar", "bahis", "uyuşturucu", "eroin", "kokain",
        "intihar", "kendine zarar", "çıplak",
    ]

    var allTexts: [(id: String, text: EventText)] {
        var texts: [(String, EventText)] = []
        for event in events {
            texts.append((event.id.rawValue, event.text))
            for choice in event.choices {
                texts.append(("\(event.id.rawValue).\(choice.id.rawValue)", choice.text))
                for outcome in choice.outcomes {
                    texts.append(("\(event.id.rawValue).\(choice.id.rawValue)", outcome.text))
                }
                for outcome in choice.outcomes where outcome.effects.contains(where: {
                    if case .credit = $0 { return true } else { return false }
                }) {
                    // credit metinleri de aşağıda ayrıca toplanır
                }
            }
            for effect in event.onOccur {
                if case let .credit(text) = effect { texts.append((event.id.rawValue, text)) }
            }
        }
        return texts
    }

    @Test("Yasaklı tema kelimesi geçmez")
    func bannedWords() {
        for (id, text) in allTexts {
            let lowered = text.tr.lowercased()
            for term in Self.bannedTerms {
                #expect(!lowered.contains(term), "\(id): yasaklı tema '\(term)'")
            }
        }
    }

    @Test("Metinler boş değil ve uzunluk sınırlarına uyar")
    func textLengths() {
        for event in events {
            #expect(!event.text.tr.isEmpty && event.text.tr.count <= 220,
                    "\(event.id.rawValue): olay metni sınır dışı (\(event.text.tr.count))")
            for choice in event.choices {
                #expect(!choice.text.tr.isEmpty && choice.text.tr.count <= 80,
                        "\(event.id.rawValue).\(choice.id.rawValue): seçenek metni sınır dışı")
                for outcome in choice.outcomes {
                    #expect(!outcome.text.tr.isEmpty && outcome.text.tr.count <= 200,
                            "\(event.id.rawValue).\(choice.id.rawValue): sonuç metni sınır dışı")
                }
            }
        }
    }

    @Test("String Catalog anahtarları küresel olarak benzersiz")
    func uniqueTextKeys() {
        var seen = Set<String>()
        var duplicates = Set<String>()
        for (_, text) in allTexts {
            if !seen.insert(text.key).inserted { duplicates.insert(text.key) }
        }
        // credit anahtarları birden çok olayda bilinçli paylaşılabilir (aynı rol);
        // yalnız "event." anahtarlarının benzersizliği zorunludur.
        let eventKeyDuplicates = duplicates.filter { $0.hasPrefix("event.") }
        #expect(eventKeyDuplicates.isEmpty, "çakışan anahtarlar: \(eventKeyDuplicates.sorted())")
    }

    @Test("AKE üst sınır koşulu yasak — düşük AKE ceza aracı değildir")
    func akeNeverGatesDownward() {
        for event in events {
            let allConditions = event.conditions + event.choices.flatMap(\.conditions)
            for condition in allConditions {
                if case let .maxStat(stat, _) = condition {
                    #expect(stat != .ake, "\(event.id.rawValue): maxStat(.ake) yasak")
                }
            }
        }
    }
}

@Suite("ContentLint — kapsama ve denge")
struct ContentBalanceLint {
    let events = ContentCatalog.events

    @Test("Her sezonun havuzunda yeterli olay var (≥ 6)")
    func seasonCoverage() {
        for season in Season.allCases {
            let count = events.filter {
                if case let .pool(seasons) = $0.trigger { return seasons.contains(season) }
                return false
            }.count
            #expect(count >= 6, "\(season.rawValue): havuzda yalnız \(count) olay")
        }
    }

    /// Materyal etki skoru: stat deltaları (AKE hariç) + para/10.000.
    /// AKE bilinçli olarak dışarıda — cesaretin ödülü AKE'nin kendisidir.
    private func materialScore(_ effects: [Effect]) -> Double {
        effects.reduce(0.0) { total, effect in
            switch effect {
            case let .stat(stat, delta) where stat != .ake: total + Double(delta)
            case let .money(amount): total + Double(amount) / 10_000.0
            default: total
            }
        }
    }

    private func evAndVariance(_ choice: Choice) -> (ev: Double, variance: Double) {
        let totalWeight = Double(choice.outcomes.reduce(0) { $0 + $1.weight })
        let scores = choice.outcomes.map { (weight: Double($0.weight), score: materialScore($0.effects)) }
        let ev = scores.reduce(0.0) { $0 + $1.weight * $1.score } / totalWeight
        let variance = scores.reduce(0.0) { $0 + $1.weight * ($1.score - ev) * ($1.score - ev) } / totalWeight
        return (ev, variance)
    }

    @Test("Denge kuralı: cesur seçim materyal EV'de nötr, varyansta yüksek")
    func boldChoiceBalance() {
        for event in events {
            let safeChoices = event.choices.filter { $0.boldness == .safe }
            let boldChoices = event.choices.filter { $0.boldness == .bold }
            guard let safe = safeChoices.first, !boldChoices.isEmpty else { continue }

            let safeStats = evAndVariance(safe)
            for bold in boldChoices {
                let boldStats = evAndVariance(bold)
                #expect(abs(boldStats.ev - safeStats.ev) <= 6.0,
                        "\(event.id.rawValue).\(bold.id.rawValue): EV farkı \(boldStats.ev - safeStats.ev)")
                #expect(boldStats.variance > safeStats.variance,
                        "\(event.id.rawValue).\(bold.id.rawValue): cesur seçim varyansı güvenliyi aşmıyor")
            }
        }
    }

    @Test("Cesur seçimler gerçekten var (AKE ekonomisi işlesin)")
    func boldChoicesExist() {
        let boldCount = events.flatMap(\.choices).count(where: { $0.boldness == .bold })
        #expect(boldCount >= 15, "katalogda yalnız \(boldCount) cesur seçim")
    }

    @Test("Katalog hacmi Faz 2 hedefinde (~150 olay)")
    func catalogSize() {
        #expect(events.count >= 140, "katalogda yalnız \(events.count) olay")
    }
}
