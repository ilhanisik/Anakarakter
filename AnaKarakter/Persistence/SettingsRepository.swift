import Foundation
import SwiftData

/// Kullanıcı tercihleri — değer tipi; View ve ViewModel `@Model` görmez.
struct AppSettings: Sendable, Equatable, Hashable {
    var soundEnabled: Bool = true
    var hapticsEnabled: Bool = true
    var removeAdsPurchased: Bool = false
    var consentResolved: Bool = false
}

@MainActor
protocol SettingsRepository {
    func load() throws -> AppSettings
    func save(_ settings: AppSettings) throws
}

@MainActor
struct SwiftDataSettingsRepository: SettingsRepository {
    let context: ModelContext

    func load() throws -> AppSettings {
        let model = try singleton()
        return AppSettings(
            soundEnabled: model.soundEnabled,
            hapticsEnabled: model.hapticsEnabled,
            removeAdsPurchased: model.removeAdsPurchased,
            consentResolved: model.consentResolved
        )
    }

    func save(_ settings: AppSettings) throws {
        let model = try singleton()
        model.soundEnabled = settings.soundEnabled
        model.hapticsEnabled = settings.hapticsEnabled
        model.removeAdsPurchased = settings.removeAdsPurchased
        model.consentResolved = settings.consentResolved
        try context.save()
    }

    private func singleton() throws -> SettingsModel {
        var descriptor = FetchDescriptor<SettingsModel>()
        descriptor.fetchLimit = 1
        if let existing = try context.fetch(descriptor).first { return existing }
        let fresh = SettingsModel()
        context.insert(fresh)
        return fresh
    }
}

@MainActor
final class InMemorySettingsRepository: SettingsRepository {
    private var settings: AppSettings

    init(settings: AppSettings = AppSettings()) {
        self.settings = settings
    }

    func load() throws -> AppSettings { settings }
    func save(_ settings: AppSettings) throws { self.settings = settings }
}
