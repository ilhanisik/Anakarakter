/// Cesaret etiketi — AKE'nin motoru. Güvenli seçim AKE düşürür, cesur seçim
/// yükseltir; denge kuralı gereği cesur seçim MATERYAL beklenen değerde nötr,
/// varyansta yüksektir (ContentLint doğrular). AKE bu dengenin dışındadır:
/// cesaretin ödülü AKE'dir.
public enum Boldness: String, Codable, Sendable, CaseIterable, Equatable, Hashable {
    case safe, neutral, bold

    /// Seçim çözülürken otomatik uygulanan AKE deltası.
    public var akeDelta: Int {
        switch self {
        case .safe: -3
        case .neutral: 0
        case .bold: 6
        }
    }
}

/// Takip olayı planı: `delayYears` yıl sonra kuyruğa girer (en az 1 —
/// yıl içi olay listesi yıl başında sabitlenir, determinizm sözleşmesi).
public struct FollowUp: Codable, Sendable, Equatable, Hashable {
    public let eventID: EventID
    public let delayYears: Int

    public init(eventID: EventID, delayYears: Int) {
        self.eventID = eventID
        self.delayYears = delayYears
    }
}

/// Olasılıklı sonuç: ağırlık + metin + etkiler + opsiyonel takip olayı.
public struct Outcome: Codable, Sendable, Equatable, Hashable {
    public let weight: Int
    public let text: EventText
    public let effects: [Effect]
    public let followUp: FollowUp?

    public init(weight: Int, text: EventText, effects: [Effect], followUp: FollowUp? = nil) {
        self.weight = weight
        self.text = text
        self.effects = effects
        self.followUp = followUp
    }
}

/// Karar kartı seçeneği.
public struct Choice: Codable, Sendable, Equatable, Hashable {
    public let id: ChoiceID
    public let text: EventText
    public let boldness: Boldness
    public let conditions: [Condition]
    public let outcomes: [Outcome]

    public init(id: ChoiceID, text: EventText, boldness: Boldness, conditions: [Condition] = [], outcomes: [Outcome]) {
        self.id = id
        self.text = text
        self.boldness = boldness
        self.conditions = conditions
        self.outcomes = outcomes
    }
}

/// Olayın desteye giriş biçimi.
public enum EventTrigger: Codable, Sendable, Equatable, Hashable {
    /// Omurga kilometre taşı: bu yaşta garanti tetiklenir (koşullar sağlanırsa).
    case milestone(age: Int)
    /// Sezon havuzundan seed'li ağırlıklı çekiliş.
    case pool(seasons: Set<Season>)
    /// Yalnız takip zinciriyle gelir; havuzdan asla çekilmez.
    case followUpOnly
}

/// Tekrar kuralı.
public enum Cooldown: Codable, Sendable, Equatable, Hashable {
    case oncePerLife
    /// En az bu kadar yıl arayla tekrarlanabilir.
    case years(Int)
}

/// Olay: kimlik + tetik + koşullar + ağırlık + metin + seçenekler.
/// `choices` boşsa haber olayıdır; `onOccur` etkileri doğrudan uygulanır.
public struct LifeEvent: Codable, Sendable, Equatable, Hashable {
    public let id: EventID
    public let trigger: EventTrigger
    public let conditions: [Condition]
    public let weight: Int
    public let cooldown: Cooldown
    public let text: EventText
    public let choices: [Choice]
    public let onOccur: [Effect]

    public init(
        id: EventID,
        trigger: EventTrigger,
        conditions: [Condition] = [],
        weight: Int = 10,
        cooldown: Cooldown = .oncePerLife,
        text: EventText,
        choices: [Choice] = [],
        onOccur: [Effect] = []
    ) {
        self.id = id
        self.trigger = trigger
        self.conditions = conditions
        self.weight = weight
        self.cooldown = cooldown
        self.text = text
        self.choices = choices
        self.onOccur = onOccur
    }

    public var isDecision: Bool { !choices.isEmpty }
}
