/// EventCatalog — olay içeriğinin tip güvenli, derleyici denetimli yuvası.
///
/// İçerik hattı (docs/02-ARCHITECTURE):
/// - Olaylar Faz 1'de `LifeDomain` şemasına uyan Swift katalog dosyaları
///   olarak bu klasöre eklenir (dış dosya formatı YOK).
/// - Metinler String Catalog anahtarına işaret eder (yerelleştirilebilir şema).
/// - Her içerik değişikliği ContentLint test kapısından geçer.
enum EventCatalog {}
