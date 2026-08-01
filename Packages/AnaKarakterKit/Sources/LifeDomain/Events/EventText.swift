/// Yerelleştirilebilir olay metni: `key` String Catalog anahtarıdır (Faz 2'de
/// arayüz bu anahtar üzerinden okur), `tr` MVP'nin Türkçe kaynak metnidir ve
/// ContentLint denetiminden geçer (uzunluk, içerik çizgisi).
public struct EventText: Codable, Sendable, Equatable, Hashable {
    public let key: String
    public let tr: String

    public init(key: String, tr: String) {
        self.key = key
        self.tr = tr
    }
}
