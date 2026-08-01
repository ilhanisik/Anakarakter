/// Hayat Puanı — şeffaf ve saf formül (docs/01):
/// yaş + stat dengesi + AKE zirvesi + başarımlar (jenerik rolleri).
///
///     puan = ölümYaşı
///          + (sağlık + mutluluk + zekâ + sosyal) / 8   → 0–50
///          + AKE zirvesi                                → 0–100
///          + rol sayısı × 5
///
/// Düşük AKE ceza DEĞİLDİR: AKE bileşeni yalnız ekler, asla çıkarmaz
/// ("mütevazı efsane" de puanını yaşayarak toplar).
public enum LifeScore {
    public static func score(for state: LifeState) -> Int {
        let age = state.deathAge ?? state.age
        let s = state.stats
        let balance = (s.health + s.happiness + s.intelligence + s.social) / 8
        let achievements = state.credits.count * 5
        return age + balance + state.peakAKE + achievements
    }
}
