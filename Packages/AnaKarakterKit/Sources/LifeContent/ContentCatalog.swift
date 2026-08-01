import LifeDomain

/// Ana Karakter içerik kataloğu — MVP Faz 1 çekirdeği.
/// Derleyici denetimli (dış dosya formatı yok); şema + içerik çizgisi
/// denetimleri `ContentLintTests` hedefinde koşar.
public enum ContentCatalog {
    /// Tüm olaylar. Sıra deterministiktir ve determinizm sözleşmesinin
    /// parçasıdır — bölüm sırasını değiştirmek destenin çekilişini değiştirir.
    public static let events: [LifeEvent] =
        MilestoneEvents.all
        + MilestoneEventsB.all
        + ChainEvents.all
        + ChildhoodEvents.all
        + ChildhoodEventsB.all
        + SchoolEvents.all
        + SchoolEventsB.all
        + CrossroadsEvents.all
        + CrossroadsEventsB.all
        + FoundationEvents.all
        + FoundationEventsB.all
        + MidlifeEvents.all
        + MidlifeEventsB.all
        + FinalSeasonEvents.all
        + FinalSeasonEventsB.all

    /// Oyunun aktif kataloğu.
    public static let catalog = EventCatalog(events: events, pools: PersonPoolsContent.pools)
}
