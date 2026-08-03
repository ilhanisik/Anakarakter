import LifeDomain

/// Çocukluk (0–5): aile, mahalle, ilk kıvılcım.
enum ChildhoodEvents {
    static let all: [LifeEvent] = [

        news(
            "cocukluk.ilkKelime", seasons: [.cocukluk], from: 1, to: 2, w: 12,
            tr: "İlk kelimen çıktı! Kayda alınamadı ama iddialar büyük: herkes kendi adının söylendiğinden emin.",
            fx: [hp(2)]
        ),

        decision(
            "cocukluk.ilkKivilcim", seasons: [.cocukluk], from: 3, w: 12,
            tr: "Bir şey içinde kıvılcım çaktı. Gözlerin hep aynı yöne kayıyor.",
            choices: [
                choice("cocukluk.ilkKivilcim", "kitap", .neutral,
                    tr: "Kitapların dünyası",
                    outcomes: [
                        outcome("cocukluk.ilkKivilcim", "kitap", 1,
                            tr: "Resimli kitaplar ezberlendi; sayfaları yalayarak çevirme dönemi kısa sürdü.",
                            fx: [iq(4), flag(.kitapKurdu)]),
                    ]),
                choice("cocukluk.ilkKivilcim", "top", .neutral,
                    tr: "Top ve sokak",
                    outcomes: [
                        outcome("cocukluk.ilkKivilcim", "top", 1,
                            tr: "Sokağın en küçük ama en hızlı oyuncusu sensin.",
                            fx: [hl(4), flag(.sporcuRuh)]),
                    ]),
                choice("cocukluk.ilkKivilcim", "sahne", .neutral,
                    tr: "Şarkılar ve taklitler",
                    outcomes: [
                        outcome("cocukluk.ilkKivilcim", "sahne", 1,
                            tr: "Aile toplantılarının açılış numarası artık senden sorulur.",
                            fx: [so(4), flag(.sahneAski)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.bayramHarcligi", seasons: [.cocukluk], from: 3, w: 10, cd: .years(2),
            tr: "Bayramda el öptün; harçlıklar ceplere sığmadı, annene emanet edildi (bir daha görülmedi).",
            fx: [hp(3), tl(500)]
        ),

        decision(
            "cocukluk.misket", seasons: [.cocukluk], from: 4, w: 10,
            tr: "Mahalle misket turnuvası. Ortada şekerden bir servet dönüyor.",
            choices: [
                choice("cocukluk.misket", "izle", .safe,
                    tr: "Kenardan izle",
                    outcomes: [
                        outcome("cocukluk.misket", "izle", 1,
                            tr: "Taktik topladın; seyirci koltuğu da güvenlidir.",
                            fx: [hp(1)]),
                    ]),
                choice("cocukluk.misket", "oyna", .bold,
                    tr: "Şekerleri ortaya koy, hepsine oyna",
                    outcomes: [
                        outcome("cocukluk.misket", "oyna", 1,
                            tr: "Hepsini süpürdün! Cebinde şeker, mahallede nam.",
                            fx: [hp(6)]),
                        outcome("cocukluk.misket", "oyna", 2,
                            tr: "Şekerler gitti. Misket ekonomisinin ilk acı dersi.",
                            fx: [hp(-4)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.komsuBoregi", seasons: [.cocukluk], w: 10, cd: .years(3),
            tr: "Komşu teyzenin böreği kapıdan tepsiyle girdi. Mahallede tok gezmek serbest.",
            fx: [hp(2)]
        ),

        decision(
            "cocukluk.uykuDirenisi", seasons: [.cocukluk], from: 3, w: 10,
            tr: "Yatma saati geldi ama televizyonda güzel bir şey var gibi... hep var zaten.",
            choices: [
                choice("cocukluk.uykuDirenisi", "uyu", .safe,
                    tr: "Söz dinle, uyu",
                    outcomes: [
                        outcome("cocukluk.uykuDirenisi", "uyu", 1,
                            tr: "Mışıl mışıl. Sabah ilk kalkan sendin.",
                            fx: [hl(2)]),
                    ]),
                choice("cocukluk.uykuDirenisi", "direnis", .bold,
                    tr: "Direniş! Koltuk arkası gizli izleme",
                    outcomes: [
                        outcome("cocukluk.uykuDirenisi", "direnis", 1,
                            tr: "Fark edilmedin ve film güzeldi. Efsane gece.",
                            fx: [hp(5)]),
                        outcome("cocukluk.uykuDirenisi", "direnis", 2,
                            tr: "Koltuğun arkasında uyuyakalmışsın; ertesi gün yürüyen zombi.",
                            fx: [hl(-3)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.mahalleMaci", seasons: [.cocukluk], from: 4, w: 10,
            tr: "Mahalle maçında büyükler seni kaleye dikti. İki gol yedin, bir efsane kurtarış yaptın; konuşulan hep kurtarış.",
            fx: [so(2)]
        ),

        decision(
            "cocukluk.parkKesfi", seasons: [.cocukluk], from: 3, w: 10,
            tr: "Parkta yeni kaydırak açıldı: yüksek, parlak ve gıcır gıcır.",
            choices: [
                choice("cocukluk.parkKesfi", "salincak", .safe,
                    tr: "Salıncak sırasını bekle",
                    outcomes: [
                        outcome("cocukluk.parkKesfi", "salincak", 1,
                            tr: "Sıra geldi, gökyüzüne sallandın. Klasikler eskimez.",
                            fx: [so(1)]),
                    ]),
                choice("cocukluk.parkKesfi", "kaydirak", .bold,
                    tr: "En yüksekten kay",
                    outcomes: [
                        outcome("cocukluk.parkKesfi", "kaydirak", 1, w: 2,
                            tr: "Parkın kahramanı ilan edildin; küçükler arkanda sıraya girdi.",
                            fx: [hp(5)]),
                        outcome("cocukluk.parkKesfi", "kaydirak", 2,
                            tr: "İniş sert oldu, diz kanadı. Yara bandı gururla taşınıyor.",
                            fx: [hl(-4)]),
                    ]),
            ]
        ),

        // Bebeklik (0–2): yaş bandı kapıları geldikten sonra bu yılların
        // havuzu ince kalmasın diye eklendi (docs/03 Faz 3 his turu).

        news(
            "cocukluk.geceNobeti", seasons: [.cocukluk], to: 1, w: 10, cd: .years(1),
            tr: "Evde gece nöbeti düzeni kuruldu: üç saatte bir uyanılıyor, kimse şikâyet etmiyor (yüksek sesle).",
            fx: [hp(2)]
        ),

        news(
            "cocukluk.ilkDis", seasons: [.cocukluk], from: 0, to: 2, w: 10,
            tr: "İlk diş göründü! Kaşık tutan herkes aynı cümleyi kurdu: 'Bak bak, çıkmış!'",
            fx: [hl(2), hp(1)]
        ),

        decision(
            "cocukluk.emeklemeTuru", seasons: [.cocukluk], to: 1, w: 10,
            tr: "Emekleme menzili genişledi. Salonun öbür ucundaki kitaplık ilgi çekici görünüyor.",
            choices: [
                choice("cocukluk.emeklemeTuru", "hali", .safe,
                    tr: "Halının güvenli alanında kal",
                    outcomes: [
                        outcome("cocukluk.emeklemeTuru", "hali", 1,
                            tr: "Halı turu tamamlandı; herkes rahat, sen keyifli.",
                            fx: [hp(2)]),
                    ]),
                choice("cocukluk.emeklemeTuru", "kitaplik", .bold,
                    tr: "Kitaplığa doğru sefer düzenle",
                    outcomes: [
                        outcome("cocukluk.emeklemeTuru", "kitaplik", 1, w: 2,
                            tr: "Rafın en alt katı fethedildi; ilk kitabın kapağı ıslak ama seninmiş.",
                            fx: [hp(5)]),
                        outcome("cocukluk.emeklemeTuru", "kitaplik", 2,
                            tr: "Yolda takla atıldı; iki dakika ağlama, sonra tekrar sefer hazırlığı.",
                            fx: [hp(-4)]),
                    ]),
            ]
        ),

        decision(
            "cocukluk.mamaMasasi", seasons: [.cocukluk], from: 1, to: 2, w: 10,
            tr: "Mama sandalyesinde tabak duruyor. Kaşık sana uzatıldı: 'Kendin mi?'",
            choices: [
                choice("cocukluk.mamaMasasi", "yardim", .safe,
                    tr: "Uzatılan kaşığı kabul et",
                    outcomes: [
                        outcome("cocukluk.mamaMasasi", "yardim", 1,
                            tr: "Tabak temiz, önlük temiz, herkes memnun.",
                            fx: [hl(2)]),
                    ]),
                choice("cocukluk.mamaMasasi", "kendim", .bold,
                    tr: "Kaşığı kap, kendin dene",
                    outcomes: [
                        outcome("cocukluk.mamaMasasi", "kendim", 1, w: 2,
                            tr: "Yarısı ağza gitti, yarısı duvara. Bağımsızlık ilan edildi.",
                            fx: [hp(5)]),
                        outcome("cocukluk.mamaMasasi", "kendim", 2,
                            tr: "Tabak ters döndü; mutfak yarım saat, moral iki dakika kayıp verdi.",
                            fx: [hp(-4)]),
                    ]),
            ]
        ),
    ]
}
