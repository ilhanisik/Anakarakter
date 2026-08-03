import Foundation
import SwiftData
import LifeDomain

/// SwiftData şeması — ilk günden sürümlenmiş (CLAUDE.md: `VersionedSchema` +
/// migration plan ilk günden). Model tiplerinin adı ve alanları bu enum'un
/// dışında değiştirilmez; değişiklik yeni bir `SchemaV2` gerektirir.
enum SchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [LifeRecordModel.self, DailyRunModel.self, StreakModel.self, SettingsModel.self]
    }
}

/// Hangi modda yaşanmış bir ömür.
enum LifeMode: String, Codable, Sendable, CaseIterable {
    case free
    case daily
}

/// Biten bir hayat — Jenerik Arşivi'nin kaydı.
///
/// Kartın GÖRSELİ değil VERİSİ saklanır (docs/02 karar günlüğü): tema veya
/// tipografi değişse bile arşiv tutarlı kalır, kart yeniden çizilir.
/// `creditsData` bir `CreditsCard` JSON'udur; seed'ler de tutulur ki hayat
/// istenirse birebir yeniden simüle edilebilsin (determinizm sözleşmesi).
@Model
final class LifeRecordModel {
    // `#Index`/`#Unique` iOS 18+ gerektirir; hedef iOS 17. Benzersizlik
    // uygulama tarafında korunur (arşiv kaydı yalnız hayat bitince, bir kez
    // yazılır), sıralama alan sayısı küçük olduğu için indekssiz yeterli.

    var id: UUID = UUID()
    var personSeed: UInt64 = 0
    var deckSeed: UInt64 = 0
    var modeRaw: String = LifeMode.free.rawValue
    var finishedAt: Date = Date.distantPast

    // Listede kart çözmeden gösterilebilecek özet alanlar.
    var name: String = ""
    var neighborhood: String = ""
    var birthYear: Int = 0
    var finalYear: Int = 0
    var lifeScore: Int = 0
    var peakAKE: Int = 0

    /// `CreditsCard` JSON'u.
    var creditsData: Data = Data()

    var mode: LifeMode { LifeMode(rawValue: modeRaw) ?? .free }

    init(
        id: UUID = UUID(),
        personSeed: UInt64,
        deckSeed: UInt64,
        mode: LifeMode,
        finishedAt: Date,
        card: CreditsCard,
        creditsData: Data
    ) {
        self.id = id
        self.personSeed = personSeed
        self.deckSeed = deckSeed
        self.modeRaw = mode.rawValue
        self.finishedAt = finishedAt
        self.name = card.name
        self.neighborhood = card.neighborhood
        self.birthYear = card.birthYear
        self.finalYear = card.finalYear
        self.lifeScore = card.lifeScore
        self.peakAKE = card.peakAKE
        self.creditsData = creditsData
    }
}

/// Bir Günün Hayatı koşusu. `dayNumber` proleptik Gregoryen gün numarasıdır
/// (`DailyDate.dayNumber`) — sıralama ve "kaç gün arayla" hesabı saf kalsın diye.
@Model
final class DailyRunModel {
    // Gün başına tek kayıt: `recordRun` önce var mı diye bakar (iOS 17'de
    // `#Unique` yok).

    var dayNumber: Int = 0
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var lifeRecordID: UUID?
    var completedAt: Date = Date.distantPast

    var date: DailyDate { DailyDate(year: year, month: month, day: day) }

    init(date: DailyDate, lifeRecordID: UUID?, completedAt: Date) {
        self.dayNumber = date.dayNumber
        self.year = date.year
        self.month = date.month
        self.day = date.day
        self.lifeRecordID = lifeRecordID
        self.completedAt = completedAt
    }
}

/// Seri durumu — tek satır (singleton). Kurallar domain'de (`StreakRules`).
@Model
final class StreakModel {
    var current: Int = 0
    var best: Int = 0
    var graceRemaining: Int = 0
    var lastPlayedYear: Int?
    var lastPlayedMonth: Int?
    var lastPlayedDay: Int?

    init(state: StreakState) {
        apply(state)
    }

    var state: StreakState {
        var last: DailyDate?
        if let y = lastPlayedYear, let m = lastPlayedMonth, let d = lastPlayedDay {
            last = DailyDate(year: y, month: m, day: d)
        }
        return StreakState(lastPlayed: last, current: current, best: best, graceRemaining: graceRemaining)
    }

    func apply(_ state: StreakState) {
        current = state.current
        best = state.best
        graceRemaining = state.graceRemaining
        lastPlayedYear = state.lastPlayed?.year
        lastPlayedMonth = state.lastPlayed?.month
        lastPlayedDay = state.lastPlayed?.day
    }
}

/// Kullanıcı tercihleri — tek satır (singleton).
@Model
final class SettingsModel {
    var soundEnabled: Bool = true
    var hapticsEnabled: Bool = true
    var removeAdsPurchased: Bool = false
    /// UMP onayı alındı mı (yeniden sormamak için; iptal her zaman mümkün).
    var consentResolved: Bool = false

    init(
        soundEnabled: Bool = true,
        hapticsEnabled: Bool = true,
        removeAdsPurchased: Bool = false,
        consentResolved: Bool = false
    ) {
        self.soundEnabled = soundEnabled
        self.hapticsEnabled = hapticsEnabled
        self.removeAdsPurchased = removeAdsPurchased
        self.consentResolved = consentResolved
    }
}

/// Şu an tek sürüm var; plan yine de ilk günden kurulur ki V2 geldiğinde
/// yeri hazır olsun (CLAUDE.md).
enum AnaKarakterMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [SchemaV1.self] }
    static var stages: [MigrationStage] { [] }
}
