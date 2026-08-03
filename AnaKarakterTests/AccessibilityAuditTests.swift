import XCTest

/// Faz 5 kabul kriteri: `performAccessibilityAudit` ana ekranlarda yeşil
/// (docs/03). Denetim; kontrast, dokunma hedefi boyutu, eksik etiket,
/// kırpılmış metin ve dinamik tip sorunlarını sistem tarafından tarar.
///
/// Uygulama `--uitest-clean` ile açılır: temiz bellek içi mağaza, reklamsız
/// akış, deterministik davranış (Köken deseni).
final class AccessibilityAuditTests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitest-clean"]
        app.launch()
    }

    func testMenuIsAccessible() throws {
        XCTAssertTrue(app.staticTexts["Ana Karakter"].waitForExistence(timeout: 10))
        try app.performAccessibilityAudit()
    }

    func testLifeFlowIsAccessible() throws {
        try startNewLife()
        try app.performAccessibilityAudit()
    }

    /// Yıl akışında birkaç yıl ilerleyip kart + seçim düzenini denetler.
    func testDecisionLayoutIsAccessible() throws {
        try startNewLife()
        for _ in 0..<6 {
            tapPrimaryAction()
        }
        try app.performAccessibilityAudit()
    }

    func testArchiveIsAccessible() throws {
        app.buttons["Jenerik Arşivi"].firstMatch.tap()
        XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: 5))
        try app.performAccessibilityAudit()
    }

    func testSettingsIsAccessible() throws {
        app.buttons["Ayarlar"].firstMatch.tap()
        XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: 5))
        try app.performAccessibilityAudit()
    }

    // MARK: Yardımcılar

    private func startNewLife() throws {
        let newLife = app.buttons["Yeni Hayat"].firstMatch
        XCTAssertTrue(newLife.waitForExistence(timeout: 10))
        newLife.tap()
        XCTAssertTrue(app.buttons["Yılı Yaşa"].firstMatch.waitForExistence(timeout: 5))
    }

    /// Ekranın altındaki birincil eylem: "Yılı Yaşa" ya da ilk seçenek.
    private func tapPrimaryAction() {
        let liveYear = app.buttons["Yılı Yaşa"].firstMatch
        if liveYear.exists, liveYear.isHittable {
            liveYear.tap()
            return
        }
        // Karar bekleniyorsa ilk seçeneği seç.
        let choices = app.buttons.allElementsBoundByIndex.filter { $0.isHittable }
        choices.last?.tap()
    }
}
