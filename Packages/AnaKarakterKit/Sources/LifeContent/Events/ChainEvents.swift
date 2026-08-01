import LifeDomain

/// Yalnız takip zinciriyle gelen olaylar (havuzdan çekilmez).
enum ChainEvents {
    static let all: [LifeEvent] = [

        // ÖSYM → üniversite ilk yılı → (3 yıl sonra) mezuniyet
        chained(
            "yol.universite",
            tr: "Üniversitenin ilk yılı: yeni şehir, yeni yüzler, kantin fiyatları hariç her şey heyecan verici.",
            choices: [
                choice("yol.universite", "duzen", .safe,
                    tr: "Yurtta düzenli bir hayat kur",
                    outcomes: [
                        outcome("yol.universite", "duzen", 1,
                            tr: "Not ortalaman parlıyor; yurt kantininin çayı sana emanet.",
                            fx: [iq(3)],
                            follow: follow("yol.mezuniyet", delay: 4)),
                    ]),
                choice("yol.universite", "kulup", .bold,
                    tr: "Kulüp kur, kampüs festivali organize et",
                    outcomes: [
                        outcome("yol.universite", "kulup", 1,
                            tr: "Festival efsane oldu; kampüste adını herkes biliyor.",
                            fx: [so(7), rol("organizator", "Kampüsün organizatörü")],
                            follow: follow("yol.mezuniyet", delay: 4)),
                        outcome("yol.universite", "kulup", 2,
                            tr: "Organizasyon büyüdü, dersler küçüldü; bütünlemeler seni bekliyor.",
                            fx: [iq(-5)],
                            follow: follow("yol.mezuniyet", delay: 4)),
                    ]),
            ]
        ),

        chained(
            "yol.mezuniyet",
            cond: [.hasFlag(.universiteli)],
            tr: "Kep havada, aile ön sırada. Jenerikte güzel bir sahne daha.",
            fx: [hp(3), flag(.mezun), rol("diplomali", "Diplomalı")]
        ),

        // Evlilik teklifi → düğün
        chained(
            "kurulus.dugun",
            cond: [.hasFlag(.evli)],
            tr: "Düğün günü geldi. Takı listesi hazır, halalar cephede.",
            choices: [
                choice("kurulus.dugun", "salon", .safe,
                    tr: "Salon düğünü: davul, zurna, takı merasimi",
                    outcomes: [
                        outcome("kurulus.dugun", "salon", 1,
                            tr: "Takılar bozduruldu, ev kuruldu. Halan hâlâ oynadığı videoyu paylaşıyor.",
                            fx: [so(4), tl(150_000), rol("elSanati", "Düğün klasiği")]),
                    ]),
                choice("kurulus.dugun", "kacamak", .bold,
                    tr: "Küçük tören, bütçe balayına",
                    outcomes: [
                        outcome("kurulus.dugun", "kacamak", 1,
                            tr: "Sahil kasabasında rüya gibi bir tören; telefonlar bir gün kapalı kaldı.",
                            fx: [hp(9), tl(80_000)]),
                        outcome("kurulus.dugun", "kacamak", 2,
                            tr: "Törende yağmur bastırdı; ıslak ama gülümseyen fotoğraflar kaldı.",
                            fx: [hp(4), tl(90_000)]),
                    ]),
            ]
        ),
    ]
}
