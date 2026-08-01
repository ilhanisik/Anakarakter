import Testing
@testable import LifeDomain

@Suite("LifeDomain iskeleti")
struct LifeDomainTests {
    @Test("Şema sürümü 1'den başlar")
    func schemaVersionStartsAtOne() {
        #expect(LifeDomain.schemaVersion == 1)
    }
}
