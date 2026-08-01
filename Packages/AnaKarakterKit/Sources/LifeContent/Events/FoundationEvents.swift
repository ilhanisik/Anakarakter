import LifeDomain

/// Kuruluş (25–39): kariyer, kira, evlilik, çocuk.
enum FoundationEvents {
    static let all: [LifeEvent] = [

        news(
            "kurulus.kiraZammi", seasons: [.kurulus], w: 14,
            cond: [.lacksFlag(.evSahibi)], cd: .years(2),
            tr: "Ev sahibi aradı: 'Evladım gibisin ama... piyasa malum.' Kira zammı geldi.",
            fx: [tl(-20_000), hp(-2)]
        ),

        decision(
            "kurulus.tanisma", seasons: [.kurulus], w: 10,
            cond: [.lacksFlag(.iliskide), .lacksFlag(.evli)], cd: .years(2),
            tr: "Arkadaş ortamında biriyle tanıştın; muhabbet kendiliğinden koyulaştı.",
            choices: [
                choice("kurulus.tanisma", "sohbet", .safe,
                    tr: "Güzel bir sohbetle bırak",
                    outcomes: [
                        outcome("kurulus.tanisma", "sohbet", 1,
                            tr: "Hoş bir akşamdı; belki yollar yine kesişir.",
                            fx: [hp(1)]),
                    ]),
                choice("kurulus.tanisma", "numara", .bold,
                    tr: "Numarayı iste",
                    outcomes: [
                        outcome("kurulus.tanisma", "numara", 1, w: 2,
                            tr: "Kahve sözü alındı! Telefon ekranına gülümseyerek bakma dönemi başladı.",
                            fx: [hp(6), flag(.iliskide)]),
                        outcome("kurulus.tanisma", "numara", 2,
                            tr: "Kibarca 'arkadaş kalalım' geldi. Olsun; cesaret hanesine yazıldı.",
                            fx: [hp(-4)]),
                    ]),
            ]
        ),

        decision(
            "kurulus.evlilikTeklifi", seasons: [.kurulus], w: 12,
            cond: [.hasFlag(.iliskide), .lacksFlag(.evli)],
            tr: "İlişkiniz güzel gidiyor; büyük soru havada asılı duruyor.",
            choices: [
                choice("kurulus.evlilikTeklifi", "devam", .safe,
                    tr: "Böyle iyi; akışında devam",
                    outcomes: [
                        outcome("kurulus.evlilikTeklifi", "devam", 1,
                            tr: "Aceleye gerek yok; kahvaltılar uzun, kalpler rahat.",
                            fx: [hp(2)]),
                    ]),
                choice("kurulus.evlilikTeklifi", "teklif", .bold,
                    tr: "Büyük soruyu sor",
                    outcomes: [
                        outcome("kurulus.evlilikTeklifi", "teklif", 1, w: 3,
                            tr: "EVET! Telefonlar kilitlendi, iki aile aynı anda ağladı.",
                            fx: [hp(6), flag(.evli)],
                            follow: follow("kurulus.dugun", delay: 1)),
                        outcome("kurulus.evlilikTeklifi", "teklif", 2,
                            tr: "'Henüz hazır değilim' cevabı geldi; yollar nazikçe ayrıldı.",
                            fx: [hp(-6), unflag(.iliskide)]),
                    ]),
            ]
        ),

        decision(
            "kurulus.cocuk", seasons: [.kurulus], w: 12,
            cond: [.hasFlag(.evli), .lacksFlag(.cocukVar)],
            tr: "Ev sessiz, kalpler dolu. 'Bebek?' konusu masada.",
            choices: [
                choice("kurulus.cocuk", "haziriz", .neutral,
                    tr: "Hazırız",
                    outcomes: [
                        outcome("kurulus.cocuk", "haziriz", 1,
                            tr: "Eve minik bir başrol katıldı. Uykusuz ama bambaşka mutlu günler.",
                            fx: [hp(6), tl(-30_000), flag(.cocukVar), rol("ebeveyn", "Ebeveyn")]),
                    ]),
                choice("kurulus.cocuk", "bekle", .neutral,
                    tr: "Biraz daha bekleyelim",
                    outcomes: [
                        outcome("kurulus.cocuk", "bekle", 1,
                            tr: "İkinize de zaman lazım; kararların en güzeli birlikte verilenidir.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),

        decision(
            "kurulus.terfi", seasons: [.kurulus], w: 12,
            cond: [.hasFlag(.calisiyor)],
            tr: "Müdür seni odaya çağırdı; masada iki dosya var.",
            choices: [
                choice("kurulus.terfi", "zam", .safe,
                    tr: "Mevcut koltukta küçük zam",
                    outcomes: [
                        outcome("kurulus.terfi", "zam", 1,
                            tr: "Zam geldi, düzen bozulmadı. Konfor bölgesinin de hakkı var.",
                            fx: [tl(30_000), hp(1)]),
                    ]),
                choice("kurulus.terfi", "ekip", .bold,
                    tr: "Yeni kurulan ekibin başına geç",
                    outcomes: [
                        outcome("kurulus.terfi", "ekip", 1,
                            tr: "Ekip tuttu; toplantılarda adın 'çözüm' ile aynı cümlede geçiyor.",
                            fx: [hp(5), tl(40_000), flag(.lider), rol("ekipKaptani", "Ekip kaptanı")]),
                        outcome("kurulus.terfi", "ekip", 2,
                            tr: "Ekip dağıldı; sana kalan üç rapor ve kocaman bir yorgunluk.",
                            fx: [hp(-5), tl(-10_000)]),
                    ]),
            ]
        ),

        decision(
            "kurulus.aracAlimi", seasons: [.kurulus], w: 10,
            cond: [.minMoney(100_000), .lacksFlag(.arabaVar)],
            tr: "İlan sitesinde bir araba: 'Az kullanılmış, sadece bayramlarda binilmiş.'",
            choices: [
                choice("kurulus.aracAlimi", "galeri", .safe,
                    tr: "Galeriden garantili al",
                    outcomes: [
                        outcome("kurulus.aracAlimi", "galeri", 1,
                            tr: "Faturalı, garantili, gönül rahat. İlk iş: koltuk naylonunu sökmemek.",
                            fx: [tl(-90_000), hp(3), flag(.arabaVar)]),
                    ]),
                choice("kurulus.aracAlimi", "sahibinden", .bold,
                    tr: "Sahibinden pazarlıkla al",
                    outcomes: [
                        outcome("kurulus.aracAlimi", "sahibinden", 1, w: 2,
                            tr: "Pazarlık dehası! Çay içildi, el sıkışıldı, anahtar cepte.",
                            fx: [tl(-60_000), hp(4), flag(.arabaVar)]),
                        outcome("kurulus.aracAlimi", "sahibinden", 2,
                            tr: "Motor sesi ilk haftada 'değişik' gelmeye başladı. Ustan artık yakın dostun.",
                            fx: [tl(-70_000), hp(-3), flag(.arabaVar)]),
                    ]),
            ]
        ),

        decision(
            "kurulus.yanGelir", seasons: [.kurulus], w: 10,
            tr: "Herkes bir 'yan iş' konuşuyor; senin de aklında bir şey var.",
            choices: [
                choice("kurulus.yanGelir", "odak", .safe,
                    tr: "Maaşına ve işine odaklan",
                    outcomes: [
                        outcome("kurulus.yanGelir", "odak", 1,
                            tr: "Enerjin tek hedefte; işinde gözle görülür bir sıçrama var.",
                            fx: [iq(1)]),
                    ]),
                choice("kurulus.yanGelir", "satis", .bold,
                    tr: "El emeği ürünlerini satışa aç",
                    outcomes: [
                        outcome("kurulus.yanGelir", "satis", 1,
                            tr: "Sipariş yağıyor! Mutfak masası atölyeye döndü.",
                            fx: [tl(50_000), hp(3), flag(.girisimciRuh), rol("markaPatronu", "Kendi markasının patronu")]),
                        outcome("kurulus.yanGelir", "satis", 2,
                            tr: "Stok evde kaldı; bu bayram herkese el emeği hediye.",
                            fx: [tl(-30_000), hp(-3)]),
                    ]),
            ]
        ),

        news(
            "kurulus.bayramZiyareti", seasons: [.kurulus], w: 12, cd: .years(2),
            tr: "Bayram turu: üç şehir, dokuz ev, sayısız çay. Kolonya kokusu üstünden bir hafta çıkmadı.",
            fx: [so(3), hp(1)]
        ),

        decision(
            "kurulus.komsuluk", seasons: [.kurulus], w: 10, cd: .years(4),
            tr: "Yeni komşu kapıda; elinde tanışma keki, yüzünde umut.",
            choices: [
                choice("kurulus.komsuluk", "kek", .neutral,
                    tr: "Kekle karşılık ver",
                    outcomes: [
                        outcome("kurulus.komsuluk", "kek", 1,
                            tr: "Tarif alışverişi başladı; kapı zilinin sesi artık dost sesi.",
                            fx: [so(3), flag(.iyiKomsu)]),
                    ]),
                choice("kurulus.komsuluk", "kapi", .neutral,
                    tr: "Teşekkür et, nazikçe kapat",
                    outcomes: [
                        outcome("kurulus.komsuluk", "kapi", 1,
                            tr: "Kek güzeldi, sessizlik de. İntrovert huzuru korundu.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),

        decision(
            "kurulus.evAlma", seasons: [.kurulus], w: 8,
            cond: [.minMoney(400_000), .lacksFlag(.evSahibi)],
            tr: "Birikim bir eşiği geçti; emlak ilanları artık 'hayal' klasöründen çıktı.",
            choices: [
                choice("kurulus.evAlma", "kenar", .safe,
                    tr: "Kenar mahallede derli toplu bir daire",
                    outcomes: [
                        outcome("kurulus.evAlma", "kenar", 1,
                            tr: "Tapu cepte! Balkondan mahalle manzarası, içeride huzur.",
                            fx: [tl(-380_000), hp(4), flag(.evSahibi), rol("evSahibi", "Ev sahibi")]),
                    ]),
                choice("kurulus.evAlma", "merkez", .bold,
                    tr: "Merkezde iddialı bir daire",
                    outcomes: [
                        outcome("kurulus.evAlma", "merkez", 1,
                            tr: "Konum harika, ev değerlendi; kararın alkışlandı.",
                            fx: [tl(-380_000), hp(6), flag(.evSahibi), rol("evSahibi", "Ev sahibi")]),
                        outcome("kurulus.evAlma", "merkez", 2,
                            tr: "Aidat ve masraflar can yakıyor; asansör 'bakımda' kelimesini sevdi.",
                            fx: [tl(-380_000), hp(-4), flag(.evSahibi), rol("evSahibi", "Ev sahibi")]),
                    ]),
            ]
        ),

        decision(
            "kurulus.sporSalonu", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "Yeni yıl kararı: forma girmek. Plan hazır, motivasyon videoları izlendi.",
            choices: [
                choice("kurulus.sporSalonu", "yuruyus", .safe,
                    tr: "Mahallede yürüyüş rutini",
                    outcomes: [
                        outcome("kurulus.sporSalonu", "yuruyus", 1,
                            tr: "Her akşam sahil/park turu; adımlar arttı, kafa dinlendi.",
                            fx: [hl(3)]),
                    ]),
                choice("kurulus.sporSalonu", "salon", .neutral,
                    tr: "Salon üyeliği (ocak ayı klasiği)",
                    outcomes: [
                        outcome("kurulus.sporSalonu", "salon", 1,
                            tr: "Gerçekten gittin! Antrenör bile şaşırdı.",
                            fx: [hl(5), tl(-10_000)]),
                        outcome("kurulus.sporSalonu", "salon", 2, w: 2,
                            tr: "Üyelik kartı cüzdanda antikaya dönüştü. Niyet önemliydi.",
                            fx: [tl(-10_000), hp(-1)]),
                    ]),
            ]
        ),

        // AKE sahne olayı
        decision(
            "sahne.kurulus.girisim", seasons: [.kurulus], w: 8,
            cond: [.minStat(.ake, 70), .minMoney(50_000)],
            tr: "SAHNE SENİN: O fikir yıllardır defterinde duruyor. Defter bugün kendiliğinden o sayfada açıldı.",
            choices: [
                choice("sahne.kurulus.girisim", "kur", .bold,
                    tr: "Kur şu şirketi",
                    outcomes: [
                        outcome("sahne.kurulus.girisim", "kur", 1,
                            tr: "İlk müşteri, ilk fatura, ilk 'biz başardık' yemeği. Fikrin ayakta.",
                            fx: [tl(100_000), hp(5), flag(.girisimciRuh), rol("kurucu", "Kurucu")]),
                        outcome("sahne.kurulus.girisim", "kur", 2,
                            tr: "Pazar hazır değilmiş. Kayıp: biraz para. Kazanç: paha biçilmez ders.",
                            fx: [tl(-50_000), hp(-5), iq(2)]),
                    ]),
                choice("sahne.kurulus.girisim", "defter", .neutral,
                    tr: "Defterde biraz daha olgunlaşsın",
                    outcomes: [
                        outcome("sahne.kurulus.girisim", "defter", 1,
                            tr: "Fikir bekledikçe keskinleşiyor; sen de hazırlanıyorsun.",
                            fx: [iq(1)]),
                    ]),
            ]
        ),
    ]
}
