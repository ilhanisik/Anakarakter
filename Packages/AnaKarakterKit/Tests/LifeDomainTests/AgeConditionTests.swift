import Testing
@testable import LifeDomain

@Suite("Yaş koşulu")
struct AgeConditionTests {
    @Test("minAge/maxAge duruma göre değerlendirilir")
    func evaluation() {
        let state = Fixture.state(age: 8)
        #expect(Condition.minAge(6).isSatisfied(by: state))
        #expect(!Condition.minAge(9).isSatisfied(by: state))
        #expect(Condition.maxAge(8).isSatisfied(by: state))
        #expect(!Condition.maxAge(7).isSatisfied(by: state))
    }

    @Test("Bant kesişimi: en dar sınırlar kazanır")
    func boundsIntersect() {
        let conditions: [Condition] = [.minAge(6), .minAge(10), .maxAge(17), .maxAge(15)]
        let bounds = conditions.declaredAgeBounds
        #expect(bounds.min == 10)
        #expect(bounds.max == 15)
        #expect(conditions.ageAllows(12))
        #expect(!conditions.ageAllows(9))
        #expect(!conditions.ageAllows(16))
    }

    @Test("Yaş koşulu yoksa her yaşa izin verilir")
    func noBoundsAllowsAll() {
        let conditions: [Condition] = [.hasFlag(.kadin), .minStat(.health, 50)]
        #expect(conditions.declaredAgeBounds.min == nil)
        #expect(conditions.declaredAgeBounds.max == nil)
        #expect(conditions.ageAllows(0))
        #expect(conditions.ageAllows(LifeDomain.maximumAge))
    }

    @Test("Yaş kapısı sezon içinde de daraltır: geniş sezon tek kapı değildir")
    func narrowsWithinSeason() {
        // Okul sezonu 6–17; lise olayı yalnız 14+ çekilebilmeli.
        let liseEvent = Fixture.news("lise", seasons: [.okul], cond: [.minAge(14)])
        #expect(!EventDeck.isEligible(liseEvent, state: Fixture.state(age: 7)))
        #expect(EventDeck.isEligible(liseEvent, state: Fixture.state(age: 15)))
    }

    @Test("Yaş bandı destede gerçekten uygulanır")
    func deckRespectsAgeBand() {
        let early = Fixture.news("erken", seasons: [.okul], cond: [.maxAge(9)])
        let late = Fixture.news("gec", seasons: [.okul], cond: [.minAge(14)])
        let catalog = Fixture.catalog([early, late])

        var young = Fixture.state(age: 7)
        let youngDraw = EventDeck.drawYearEvents(state: &young, catalog: catalog)
        #expect(youngDraw.map(\.id) == [early.id])

        var old = Fixture.state(age: 16)
        let oldDraw = EventDeck.drawYearEvents(state: &old, catalog: catalog)
        #expect(oldDraw.map(\.id) == [late.id])
    }
}
