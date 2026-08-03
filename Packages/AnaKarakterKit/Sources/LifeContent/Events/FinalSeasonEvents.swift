import LifeDomain

/// Final Sezonu (65+): emeklilik, torunlar, jenerik hazırlığı.
enum FinalSeasonEvents {
    static let all: [LifeEvent] = [

        news(
            "final.torun", seasons: [.finalSezonu], from: 66, w: 12,
            cond: [.hasFlag(.cocukVar)],
            tr: "Torun geldi! Evin şeker stoğu ikiye katlandı, kurallar yarıya indi.",
            fx: [hp(6), flag(.torunVar), rol("torunSevdalisi", "Torun sevdalısı")]
        ),

        news(
            "final.emekliZammi", seasons: [.finalSezonu], w: 10,
            cond: [.hasFlag(.emekli)], cd: .years(2),
            tr: "Emekli maaşına zam geldi. Kahvehane hesabında bir şey değişmedi ama moral başka.",
            fx: [tl(10_000), hp(1)]
        ),

        news(
            "final.parkArkadaslari", seasons: [.finalSezonu], w: 10, cd: .years(3),
            tr: "Parktaki bankın müdavimleri seni aralarına aldı. Gündem sabit: torunlar, tansiyon, eski bayramlar.",
            fx: [so(3)]
        ),

        decision(
            "final.anilarKutusu", seasons: [.finalSezonu], w: 10,
            tr: "Tavan arasında eski fotoğraf kutusu çıktı. Kapağında el yazınla bir tarih var.",
            choices: [
                choice("final.anilarKutusu", "album", .neutral,
                    tr: "Albüm yap, aileye dağıt",
                    outcomes: [
                        outcome("final.anilarKutusu", "album", 1,
                            tr: "Albümler bayramda dağıtıldı; her sayfada bir 'aaa bak bu kim!' koptu.",
                            fx: [hp(4), rol("arsivci", "Aile arşivcisi")]),
                    ]),
                choice("final.anilarKutusu", "kapat", .neutral,
                    tr: "Kutuyu kapat; bazı anılar orada güzel",
                    outcomes: [
                        outcome("final.anilarKutusu", "kapat", 1,
                            tr: "Kapağı usulca kapattın; gülümseme bir süre yüzünde kaldı.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),

        decision(
            "final.nasihat", seasons: [.finalSezonu], from: 70, w: 10,
            cond: [.minStat(.social, 40)], cd: .years(4),
            tr: "Mahalledeki gençler fikrini soruyor; çay senden, dikkat onlardan.",
            choices: [
                choice("final.nasihat", "hikaye", .neutral,
                    tr: "Hikâyelerle anlat",
                    outcomes: [
                        outcome("final.nasihat", "hikaye", 1,
                            tr: "'Bir de şu vardı...' diye başlayan üç saat. Gençler ertesi gün yine geldi.",
                            fx: [so(3), hp(1)]),
                    ]),
                choice("final.nasihat", "dinle", .neutral,
                    tr: "Sadece dinle",
                    outcomes: [
                        outcome("final.nasihat", "dinle", 1,
                            tr: "En iyi nasihatin dinlemek olduğunu bir kez daha kanıtladın.",
                            fx: [so(2)]),
                    ]),
            ]
        ),

        decision(
            "final.saglikKontrolu", seasons: [.finalSezonu], w: 12, cd: .years(3),
            tr: "Mevsimlik kontrol vakti. Randevu alındı, tahlil listesi hazır.",
            choices: [
                choice("final.saglikKontrolu", "duzenli", .safe,
                    tr: "Kontrolleri aksatma",
                    outcomes: [
                        outcome("final.saglikKontrolu", "duzenli", 1,
                            tr: "Erken görülen küçük şeyler küçükken halledildi. Doktorun tebrik etti.",
                            fx: [hl(4)]),
                    ]),
                choice("final.saglikKontrolu", "ilac", .neutral,
                    tr: "İlaç saatlerine sadık kal, yeter",
                    outcomes: [
                        outcome("final.saglikKontrolu", "ilac", 1,
                            tr: "Hap kutusundaki günler şaşmıyor; düzen sağlığın yarısı.",
                            fx: [hl(2)]),
                    ]),
            ]
        ),

        news(
            "final.balkonBahcesi", seasons: [.finalSezonu], w: 10, cd: .years(4),
            tr: "Balkondaki domatesler bu yıl komşulara da yetti. Tohumlar gelecek yıl için kavanozda.",
            fx: [hp(2), so(1)]
        ),

        news(
            "final.videoluArama", seasons: [.finalSezonu], w: 10, cd: .years(3),
            tr: "Uzaktaki aile videolu aradı. Kamera yarım saat alnını gösterdi ama sesler eve neşe doldurdu.",
            fx: [hp(3)]
        ),
    ]
}
