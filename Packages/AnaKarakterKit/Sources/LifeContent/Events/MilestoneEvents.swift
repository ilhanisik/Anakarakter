import LifeDomain

/// Omurga kilometre taşları — belirli yaşta garanti tetiklenir (koşul sağlanırsa).
enum MilestoneEvents {
    static let all: [LifeEvent] = [

        milestone(
            "ms.dogum", age: 0,
            tr: "Sahne 1, çekim 1: mahalleye yeni bir başrol geldi. Aile heyecanlı, komşular şimdiden isim tartışıyor.",
            fx: [hp(2)]
        ),

        milestone(
            "ms.okul.ilkGun", age: 6,
            tr: "Okulun ilk günü. Önlük ütülü, çanta kocaman, yürek pır pır.",
            choices: [
                choice("ms.okul.ilkGun", "izle", .safe,
                    tr: "Arka sıraya otur, ortamı izle",
                    outcomes: [
                        outcome("ms.okul.ilkGun", "izle", 1,
                            tr: "Gözlemci başladın; teneffüste yanına gelen oldu bile.",
                            fx: [so(2)]),
                    ]),
                choice("ms.okul.ilkGun", "tanit", .bold,
                    tr: "Tahtaya kalk, kendini tanıt",
                    outcomes: [
                        outcome("ms.okul.ilkGun", "tanit", 1,
                            tr: "Sınıf alkışladı; ilk günden ismin ezberlendi.",
                            fx: [so(7)]),
                        outcome("ms.okul.ilkGun", "tanit", 2,
                            tr: "Heyecandan kendi adını unuttun. Yıllarca anlatılacak.",
                            fx: [hp(-5)]),
                    ]),
            ]
        ),

        milestone(
            "ms.okul.lgs", age: 14,
            tr: "LGS sabahı. Tüm mahalle 'rahat ol' diyor; kimse rahat değil.",
            choices: [
                choice("ms.okul.lgs", "garanti", .safe,
                    tr: "Garanti listendeki liseyi yaz",
                    outcomes: [
                        outcome("ms.okul.lgs", "garanti", 1,
                            tr: "Yerleştin; omuzlardan koca bir yük kalktı.",
                            fx: [hp(3)]),
                    ]),
                choice("ms.okul.lgs", "hoca", .neutral,
                    tr: "Öğretmeninin önerdiği listeyi yaz",
                    outcomes: [
                        outcome("ms.okul.lgs", "hoca", 1,
                            tr: "Dengeli tercih, temiz yerleşme. Hocan gururlu.",
                            fx: [iq(2)]),
                    ]),
                choice("ms.okul.lgs", "fen", .bold,
                    cond: [.minStat(.intelligence, 55)],
                    tr: "Barajın üstündeki fen lisesini yaz",
                    outcomes: [
                        outcome("ms.okul.lgs", "fen", 1, w: 3,
                            tr: "Kazandın! Mahallede tatlı dağıtıldı.",
                            fx: [iq(8), flag(.fenLisesi)]),
                        outcome("ms.okul.lgs", "fen", 2, w: 2,
                            tr: "Puan tutmadı; mahalle lisesi seni bağrına bastı.",
                            fx: [hp(-4)]),
                    ]),
            ]
        ),

        milestone(
            "ms.yol.osym", age: 18,
            tr: "ÖSYM tercih ekranı açık. İmleç, geleceğinin üstünde titriyor.",
            choices: [
                choice("ms.yol.osym", "calis", .safe,
                    tr: "Tercih yapma; çalışma hayatına başla",
                    outcomes: [
                        outcome("ms.yol.osym", "calis", 1,
                            tr: "İlk maaş, ilk sigorta. Alın teri erken tanıştı seninle.",
                            fx: [hp(2), flag(.calisiyor), income(80_000)]),
                    ]),
                choice("ms.yol.osym", "puan", .neutral,
                    tr: "Puanına göre sağlam bir bölüm seç",
                    outcomes: [
                        outcome("ms.yol.osym", "puan", 1,
                            tr: "Tebrikler, öğrencisin! Şehir ve yurt maceraları başlasın.",
                            fx: [iq(3), flag(.universiteli)],
                            follow: follow("yol.universite", delay: 1)),
                    ]),
                choice("ms.yol.osym", "hayal", .bold,
                    cond: [.minStat(.intelligence, 60)],
                    tr: "Barajın üstündeki hayal bölümünü yaz",
                    outcomes: [
                        outcome("ms.yol.osym", "hayal", 1,
                            tr: "TUTTU! Hayaline yerleştin; ailede sevinç gözyaşları.",
                            fx: [hp(6), flag(.universiteli)],
                            follow: follow("yol.universite", delay: 1)),
                        outcome("ms.yol.osym", "hayal", 2,
                            tr: "Olmadı. Bir yıl daha deneyeceksin; masada dershane broşürleri.",
                            fx: [hp(-5)]),
                    ]),
            ]
        ),

        milestone(
            "ms.yol.askerlik", age: 21,
            cond: [.hasFlag(.erkek), .lacksFlag(.askerYapti)],
            tr: "Askerlik çağrısı geldi. Mahalle şimdiden uğurlama hazırlığında.",
            choices: [
                choice("ms.yol.askerlik", "git", .neutral,
                    tr: "Vakti geldi; git",
                    outcomes: [
                        outcome("ms.yol.askerlik", "git", 1,
                            tr: "Yemin gününde ailen gururdan ağladı; sen de biraz.",
                            fx: [so(4), flag(.askerYapti)]),
                        outcome("ms.yol.askerlik", "git", 2,
                            tr: "Zor günler oldu ama nöbet arkadaşlıkları ömürlük çıktı.",
                            fx: [so(3), hp(2), flag(.askerYapti)]),
                    ]),
                choice("ms.yol.askerlik", "tecil", .neutral,
                    tr: "Okul/iş için tecil ettir",
                    outcomes: [
                        outcome("ms.yol.askerlik", "tecil", 1,
                            tr: "Şimdilik ertelendi. Konu her aile yemeğinde açılacak ama.",
                            fx: [iq(1)]),
                    ]),
            ]
        ),

        milestone(
            "ms.kurulus.ilkIs", age: 25,
            cond: [.lacksFlag(.calisiyor)],
            tr: "İki iş teklifi aynı gün geldi. Kravat mı, sweatshirt mü?",
            choices: [
                choice("ms.kurulus.ilkIs", "garantili", .safe,
                    tr: "Köklü şirketin garantili kadrosu",
                    outcomes: [
                        outcome("ms.kurulus.ilkIs", "garantili", 1,
                            tr: "Düzenli maaş, mesai saati belli. Annen çok rahatladı.",
                            fx: [hp(2), flag(.calisiyor), income(100_000)]),
                    ]),
                choice("ms.kurulus.ilkIs", "girisim", .bold,
                    tr: "Küçük ama hevesli girişimin kadrosu",
                    outcomes: [
                        outcome("ms.kurulus.ilkIs", "girisim", 1,
                            tr: "Girişim uçuşa geçti; unvanın kartvizite sığmıyor.",
                            fx: [hp(6), flag(.calisiyor), income(160_000)]),
                        outcome("ms.kurulus.ilkIs", "girisim", 2,
                            tr: "Üç ayda küçüldüler; masan camdan uzağa taşındı.",
                            fx: [hp(-4), flag(.calisiyor), income(70_000)]),
                    ]),
            ]
        ),

        milestone(
            "ms.final.emeklilik", age: 65,
            cond: [.hasFlag(.calisiyor)],
            tr: "Son mesai günü. Pasta kesildi, plaket verildi, gözler doldu.",
            fx: [hp(3), flag(.emekli), unflag(.calisiyor), income(60_000),
                 rol("emektar", "Emektar")]
        ),
    ]
}
