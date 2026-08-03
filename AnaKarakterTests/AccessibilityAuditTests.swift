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
        try audit(#function)
    }

    func testLifeFlowIsAccessible() throws {
        try startNewLife()
        try audit(#function)
    }

    /// Yıl akışında birkaç yıl ilerleyip kart + seçim düzenini denetler.
    func testDecisionLayoutIsAccessible() throws {
        try startNewLife()
        for _ in 0..<6 {
            tapPrimaryAction()
        }
        try audit(#function)
    }

    func testArchiveIsAccessible() throws {
        app.buttons["Jenerik Arşivi"].firstMatch.tap()
        XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: 5))
        try audit(#function)
    }

    func testSettingsIsAccessible() throws {
        app.buttons["Ayarlar"].firstMatch.tap()
        XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: 5))
        try audit(#function)
    }

    // MARK: Yardımcılar

    /// Denetimi koşar ve ihlalleri **hata mesajına** toplar.
    ///
    /// `performAccessibilityAudit`'in kendi hatası yalnız "Contrast failed"
    /// diyor; hangi görünümün sorunlu olduğu komut satırından okunamıyor.
    /// Bu yüzden ihlaller elde toplanıp tek bir mesajda raporlanıyor —
    /// xcresult'tan okunabilir hâle geliyor.
    private func audit(_ screen: String) throws {
        // Kapanış Sendable olmak zorunda; birikim referans tipte tutulur.
        let box = IssueBox()
        try app.performAccessibilityAudit { issue in
            let label = issue.element?.label ?? "?"
            box.append("[\(issue.auditType)] '\(label)' — \(issue.compactDescription)")
            return true // burada yutulur; rapor aşağıda tek seferde verilir
        }
        let found = box.all
        if !found.isEmpty {
            XCTFail("DENETIM \(screen) (\(found.count)): " + found.joined(separator: " || "))
        }
    }

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

/// Denetim ihlallerini biriktiren küçük kutu (kapanış Sendable olsun diye).
final class IssueBox: @unchecked Sendable {
    private let lock = NSLock()
    private var items: [String] = []

    func append(_ text: String) {
        lock.lock(); defer { lock.unlock() }
        items.append(text)
    }

    var all: [String] {
        lock.lock(); defer { lock.unlock() }
        return items
    }
}
