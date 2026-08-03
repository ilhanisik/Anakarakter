/// "Şans Tekrarı" — bir kararın sonucunu yeniden çevirir (ödüllü yerleşim).
///
/// Kural (docs/01 + CLAUDE.md reklam politikası):
/// - Hayat başına bir kez (sınır `AdPolicy`'de, burada değil).
/// - **Ölüm geri alınamaz**: hayatın sonu pazarlık konusu değildir.
/// - Sonuç gerçekten değişebilmeli: karar öncesine dönülür ama zar
///   İLERLEMİŞ rastgelelikle atılır. Anlık görüntü RNG'yi de geri saraydı
///   aynı sonuç çıkardı ve "tekrar" bir aldatmaca olurdu.
public enum LuckRetry {
    /// Karar öncesi anlık görüntüyü, güncel durumun ilerlemiş rastgeleliğiyle
    /// birleştirir. Determinizm korunur: aynı seed + aynı kararlar + aynı
    /// tekrar kullanımı = aynı hayat.
    public static func rewind(to snapshot: LifeState, keepingRandomnessOf current: LifeState) -> LifeState {
        var restored = snapshot
        restored.rng = current.rng
        return restored
    }

    /// Bu durum bir Şans Tekrarı'na uygun mu (ölüm sonrası değil).
    public static func isEligible(_ state: LifeState) -> Bool {
        state.isAlive
    }
}
