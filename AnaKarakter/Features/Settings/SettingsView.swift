import SwiftUI

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: dependencies.makeSettingsViewModel())
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        Form {
            Section("settings.feel") {
                Toggle("settings.sound", isOn: $viewModel.soundEnabled)
                Toggle("settings.haptics", isOn: $viewModel.hapticsEnabled)
            }

            Section("settings.purchases") {
                if viewModel.removeAdsPurchased {
                    Label("settings.removeAds.owned", systemImage: "checkmark.seal.fill")
                        .foregroundStyle(DesignTokens.TextColor.secondary)
                } else {
                    Button {
                        Task { await viewModel.purchaseRemoveAds() }
                    } label: {
                        LabeledContent("settings.removeAds") {
                            if let price = viewModel.removeAdsPrice {
                                Text(verbatim: price)
                            } else {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(viewModel.isPurchasing || viewModel.removeAdsPrice == nil)

                    Button("settings.restore") {
                        Task { await viewModel.restorePurchases() }
                    }
                    .disabled(viewModel.isPurchasing)
                }
            }

            Section {
                LabeledContent("settings.archivedLives") {
                    Text(viewModel.archivedLifeCount.formatted())
                        .monospacedDigit()
                }
            } header: {
                Text("settings.archive")
            } footer: {
                // Erişilebilirlik/hareket tercihleri sistemden okunur; oyun
                // kendi kopyasını tutmaz (ayarların tek doğruluk kaynağı iOS).
                Text("settings.systemPreferences.note")
            }

            Section("settings.about") {
                LabeledContent("settings.version") {
                    Text(verbatim: Self.versionString)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(DesignTokens.Surface.canvas)
        .navigationTitle("settings.title")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.reload() }
        .alert(item: $viewModel.purchaseNotice) { notice in
            Alert(
                title: Text(Self.noticeKey(notice)),
                dismissButton: .default(Text("common.ok"))
            )
        }
    }

    private static func noticeKey(_ notice: SettingsViewModel.PurchaseNotice) -> LocalizedStringKey {
        switch notice {
        case .restored: "settings.notice.restored"
        case .pending: "settings.notice.pending"
        case .failed: "settings.notice.failed"
        }
    }

    private static var versionString: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = info?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
