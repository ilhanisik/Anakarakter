/// Ana Karakter Enerjisi'nin (AKE) ekonomisi — markanın imza göstergesi.
///
/// Sorun (docs/03 Faz 3 his turu): sabit +6'lık cesaret bonusuyla AKE 8 yaşında
/// 100'e yapışıyor ve kalan 60+ yıl düz çizgi oluyordu; gösterge bilgi taşımayı
/// bırakıyordu.
///
/// Çözüm: **azalan verim**. Cesaretin kazancı kalan başlıkla (headroom)
/// ölçeklenir — AKE ne kadar yüksekse aynı cesur seçim o kadar az yükseltir.
/// Böylece:
/// - Tepeye tırmanmak bir ömür sürer (çocuklukta zirve yapılamaz).
/// - Zirveyi korumak *sürekli* cesaret ister; bırakan düşer.
/// - Kazanç asla eksiye dönmez — "AKE ceza aracı değildir" kuralı korunur
///   (yalnız kazanç küçülür; güvenli seçimin sabit bedeli ayrı bir karardır).
///
/// Tamsayı aritmetiği bilinçlidir: determinizm sözleşmesi kayan nokta
/// yuvarlama farklarına açık bırakılmaz (aynı seed = bit-bit aynı hayat).
public enum AKEModel {
    /// Cesaret bonusunun uygulanacak hâli.
    ///
    /// - Kazanç (`base > 0`): `base × (100 − ake) / 100`, yarımlar yukarı.
    ///   AKE 0'da tam, 50'de yarım, 80'de altıda bir; ~92'den sonra 0'a iner —
    ///   yani salt cesaretle ulaşılabilen pratik tavan 100 değil ~90'dır.
    /// - Kayıp (`base <= 0`): olduğu gibi uygulanır. Güvenli oynamanın bedeli
    ///   AKE seviyesinden bağımsızdır; aksi hâlde zirvedeki oyuncu iki kat
    ///   cezalandırılmış olurdu.
    public static func appliedDelta(base: Int, currentAKE: Int) -> Int {
        guard base > 0 else { return base }
        let headroom = max(0, StatBlock.statRange.upperBound - currentAKE)
        return (base * headroom + 50) / 100
    }
}
