import LifeDomain

/// Orta Sahne (40–64) ve Final Sezonu (65+) — Faz 4 içerik genişlemesi.
/// İki sezon da uzun; yaş bandı gerektiren olaylar bandını beyan eder.
enum LateSeasonEventsC {
    static let all: [LifeEvent] = [

        // --- Orta Sahne ---

        decision(
            "orta.ustaCirak", seasons: [.ortaSahne], from: 45, w: 10, cd: .years(5),
            tr: "Sektörden genç biri 'sizinle çalışmak isterim' diye yazdı.",
            choices: [
                choice("orta.ustaCirak", "yonlendir", .safe,
                    tr: "Birkaç tavsiye ver, yolla",
                    outcomes: [
                        outcome("orta.ustaCirak", "yonlendir", 1,
                            tr: "Kısa bir görüşme oldu; yıllar sonra hâlâ o tavsiyeyi anlatıyor.",
                            fx: [so(2)]),
                    ]),
                choice("orta.ustaCirak", "yaninaAl", .bold,
                    tr: "Yanına al, öğret",
                    outcomes: [
                        outcome("orta.ustaCirak", "yaninaAl", 1, w: 2,
                            tr: "İki yılda sektöre iyi biri kazandırdın; en çok gurur duyduğun iş bu.",
                            fx: [so(7)]),
                        outcome("orta.ustaCirak", "yaninaAl", 2,
                            tr: "Yolları erken ayrıldı; emek verdiğin yerde bir boşluk kaldı.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "orta.mahalleDegisimi", seasons: [.ortaSahne], w: 8, cd: .years(5),
            tr: "Köşedeki eski dükkân kapandı, yerine yenisi açıldı. Mahalle yavaşça başka bir mahalle oluyor.",
            fx: [hp(-1), iq(1)]
        ),

        decision(
            "orta.ebeveynSagligi", seasons: [.ortaSahne], from: 48, w: 10, cd: .years(5),
            tr: "Babanın kontrolleri sıklaştı. Randevular hafta içine denk geliyor.",
            choices: [
                choice("orta.ebeveynSagligi", "ayarla", .safe,
                    tr: "İzin al, birlikte git",
                    outcomes: [
                        outcome("orta.ebeveynSagligi", "ayarla", 1,
                            tr: "Doktor odasında yan yana oturdunuz; konuşmadan çok şey söylendi.",
                            fx: [so(3), hp(1)]),
                    ]),
                choice("orta.ebeveynSagligi", "destek", .neutral,
                    tr: "Ulaşımı ve takibi organize et",
                    outcomes: [
                        outcome("orta.ebeveynSagligi", "destek", 1,
                            tr: "Her şey tıkır tıkır işledi; sen arka planda kaldın, o rahat etti.",
                            fx: [so(2)]),
                    ]),
            ]
        ),

        news(
            "orta.eskiDefter", seasons: [.ortaSahne], w: 8, cd: .years(5),
            tr: "Çekmeceden yirmi yıllık bir defter çıktı. O günkü hedeflerin bir kısmı tutmuş.",
            fx: [hp(3), iq(1)]
        ),

        decision(
            "orta.yeniSehir", seasons: [.ortaSahne], from: 45, to: 58, w: 8,
            tr: "İş, başka bir şehirde yeni bir birim kuruyor. Sana soruyorlar.",
            choices: [
                choice("orta.yeniSehir", "kal", .safe,
                    tr: "Kurulu düzende kal",
                    outcomes: [
                        outcome("orta.yeniSehir", "kal", 1,
                            tr: "Alıştığın hayat devam etti; huzur da bir kazançtır.",
                            fx: [hp(2)]),
                    ]),
                choice("orta.yeniSehir", "git", .bold,
                    tr: "Git, sıfırdan kur",
                    outcomes: [
                        outcome("orta.yeniSehir", "git", 1, w: 2,
                            tr: "Yeni şehir seni gençleştirdi; birim iki yılda ayağa kalktı.",
                            fx: [hp(6), tl(30_000)]),
                        outcome("orta.yeniSehir", "git", 2,
                            tr: "Yalnızlık ağır bastı; bir yıl sonra geri döndün.",
                            fx: [hp(-6), tl(-30_000)]),
                    ]),
            ]
        ),

        news(
            "orta.sirtAgrisi", seasons: [.ortaSahne], from: 45, w: 10, cd: .years(4),
            tr: "Sırt ağrısı sabah rutinine dâhil oldu. Fizyoterapist 'masana bak' dedi.",
            fx: [hl(-2), iq(1)]
        ),

        decision(
            "orta.ustSinir", seasons: [.ortaSahne], from: 45, to: 60, w: 8,
            cond: [.hasFlag(.calisiyor)],
            tr: "Yönetim bir üst göreve seni düşünüyor; iş yükü ikiye katlanacak.",
            choices: [
                choice("orta.ustSinir", "hayir", .safe,
                    tr: "Teşekkür et, reddet",
                    outcomes: [
                        outcome("orta.ustSinir", "hayir", 1,
                            tr: "Kendi işini iyi yapmaya devam ettin; akşamların sende kaldı.",
                            fx: [hp(2)]),
                    ]),
                choice("orta.ustSinir", "kabul", .bold,
                    tr: "Kabul et",
                    outcomes: [
                        outcome("orta.ustSinir", "kabul", 1, w: 2,
                            tr: "Koltuk sana yaradı; ekibin en iyi yılını yaşadı.",
                            fx: [hp(6), tl(40_000), rol("yonetici", "Ekip Yöneticisi")]),
                        outcome("orta.ustSinir", "kabul", 2,
                            tr: "İki yıl sonra yorgunluk baskın çıktı; geri adım atıldı.",
                            fx: [hp(-6), tl(40_000)]),
                    ]),
            ]
        ),

        news(
            "orta.komsuTaziyesi", seasons: [.ortaSahne], from: 50, w: 8, cd: .years(5),
            tr: "Apartmandan bir komşu vefat etti. Merdivende herkes birbirine daha nazik davrandı.",
            fx: [hp(-3), so(2)]
        ),

        news(
            "orta.eskiOgrenci", seasons: [.ortaSahne], from: 50, w: 8, cd: .years(5),
            tr: "Sokakta biri seni tanıdı: yıllar önce yardım ettiğin çocuk, artık kendi işini kurmuş.",
            fx: [hp(4), so(2)]
        ),

        decision(
            "orta.beslenmeDuzeni", seasons: [.ortaSahne], from: 45, w: 10, cd: .years(5),
            tr: "Tahliller 'biraz dikkat' dedi. Mutfakta bir karar bekleniyor.",
            choices: [
                choice("orta.beslenmeDuzeni", "azalt", .safe,
                    tr: "Porsiyonları küçült",
                    outcomes: [
                        outcome("orta.beslenmeDuzeni", "azalt", 1,
                            tr: "Küçük değişiklik altı ayda kendini gösterdi.",
                            fx: [hl(3)]),
                    ]),
                choice("orta.beslenmeDuzeni", "tamdegisim", .bold,
                    tr: "Düzeni tamamen değiştir",
                    outcomes: [
                        outcome("orta.beslenmeDuzeni", "tamdegisim", 1, w: 2,
                            tr: "Bir yıl sonra doktor rakamlara baktı ve gülümsedi.",
                            fx: [hl(7)]),
                        outcome("orta.beslenmeDuzeni", "tamdegisim", 2,
                            tr: "Katı düzen üç ay sürdü; sonra eskisinden beter olundu.",
                            fx: [hl(-8)]),
                    ]),
            ]
        ),

        news(
            "orta.evinSessizligi", seasons: [.ortaSahne], from: 50, w: 8, cond: [.hasFlag(.cocukVar)], cd: .years(5),
            tr: "Çocuk odası bu yıl sessiz. Kapı aralık bırakıldı; belki döner diye.",
            fx: [hp(-2), so(1)]
        ),

        news(
            "orta.yeniHobiMalzemesi", seasons: [.ortaSahne], w: 8, cond: [.hasFlag(.hobiUstasi)], cd: .years(4),
            tr: "Hobi için iyi bir malzeme alındı. Kutusu bile özenle saklandı.",
            fx: [hp(3), tl(-12_000)]
        ),

        decision(
            "orta.eskiDostKavgasi", seasons: [.ortaSahne], w: 8, cd: .years(5),
            tr: "Yıllanmış bir dostlukta kırgınlık var. İlk adımı kimse atmıyor.",
            choices: [
                choice("orta.eskiDostKavgasi", "bekle", .safe,
                    tr: "Zamana bırak",
                    outcomes: [
                        outcome("orta.eskiDostKavgasi", "bekle", 1,
                            tr: "Bir bayram sabahı mesaj geldi; buz kendi kendine çözüldü.",
                            fx: [so(2)]),
                    ]),
                choice("orta.eskiDostKavgasi", "ara", .bold,
                    tr: "Sen ara, konuş",
                    outcomes: [
                        outcome("orta.eskiDostKavgasi", "ara", 1, w: 2,
                            tr: "İki saat konuştunuz; dostluk eskisinden sağlam döndü.",
                            fx: [so(7)]),
                        outcome("orta.eskiDostKavgasi", "ara", 2,
                            tr: "Karşılık soğuktu. Denemiş olmak yine de içini rahatlattı.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "orta.kirkYilSonra", seasons: [.ortaSahne], from: 55, w: 8, cd: .years(6),
            tr: "İlkokul öğretmenini sosyal medyada buldun; bir mesaj yazdın ve cevap geldi.",
            fx: [hp(4)]
        ),

        news(
            "orta.evrakDuzeni", seasons: [.ortaSahne], from: 50, w: 8, cd: .years(5),
            tr: "Bir hafta sonu tüm evraklar düzenlendi. Klasörler etiketlendi, huzur geldi.",
            fx: [iq(2), hp(2)]
        ),

        decision(
            "orta.torununGelisi", seasons: [.ortaSahne], from: 58, w: 8, cond: [.hasFlag(.cocukVar)],
            tr: "Bir haber geldi: aileye yeni biri katılıyor.",
            choices: [
                choice("orta.torununGelisi", "hazirlik", .safe,
                    tr: "Odayı hazırla, sessizce destek ol",
                    outcomes: [
                        outcome("orta.torununGelisi", "hazirlik", 1,
                            tr: "Her şey hazırdı. Kimse sormadı ama herkes fark etti.",
                            fx: [hp(4), flag(.torunVar)]),
                    ]),
                choice("orta.torununGelisi", "kutla", .neutral,
                    tr: "Bütün mahalleye duyur",
                    outcomes: [
                        outcome("orta.torununGelisi", "kutla", 1,
                            tr: "Üç gün lokma dağıtıldı; komşular hâlâ o günü anlatıyor.",
                            fx: [so(4), flag(.torunVar)]),
                    ]),
            ]
        ),

        // --- Final Sezonu ---

        news(
            "final.sabahGazetesi", seasons: [.finalSezonu], w: 10, cd: .years(3),
            tr: "Gazete kâğıttan okunuyor, çay demli, güneş balkona vurmuş. Sabahın hakkı veriliyor.",
            fx: [hp(3)]
        ),

        decision(
            "final.gencKusakSorusu", seasons: [.finalSezonu], from: 68, w: 10, cd: .years(4),
            tr: "Torun sordu: 'Sen benim yaşımdayken ne yapıyordun?'",
            choices: [
                choice("final.gencKusakSorusu", "kisaCevap", .safe,
                    tr: "Kısa ve net anlat",
                    outcomes: [
                        outcome("final.gencKusakSorusu", "kisaCevap", 1,
                            tr: "İki cümleyle anlattın; gözlerindeki ilgi yeterdi.",
                            fx: [so(2)]),
                    ]),
                choice("final.gencKusakSorusu", "uzunHikaye", .bold,
                    tr: "Bütün hikâyeyi anlat",
                    outcomes: [
                        outcome("final.gencKusakSorusu", "uzunHikaye", 1, w: 2,
                            tr: "İki saat dinlendi. O hikâye artık aileye ait bir miras.",
                            fx: [so(7)]),
                        outcome("final.gencKusakSorusu", "uzunHikaye", 2,
                            tr: "Yarısında telefonu çaldı. Olsun; anlatmanın da bir tadı vardı.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "final.komsuKapisi", seasons: [.finalSezonu], w: 10, cd: .years(3),
            tr: "Kapı çaldı: karşı daireden tabakla bir şeyler geldi. Tabak boş gitmeyecek.",
            fx: [so(3), hp(2)]
        ),

        decision(
            "final.tasinmaTeklifi", seasons: [.finalSezonu], from: 70, w: 8,
            cond: [.hasFlag(.cocukVar)],
            tr: "Çocuğun 'bize yakın taşın' diyor. Ev eski ama her köşesi tanıdık.",
            choices: [
                choice("final.tasinmaTeklifi", "kal", .safe,
                    tr: "Kendi evinde kal",
                    outcomes: [
                        outcome("final.tasinmaTeklifi", "kal", 1,
                            tr: "Mahalle, komşular, alışkanlıklar yerinde kaldı. İyi oldu.",
                            fx: [hp(3)]),
                    ]),
                choice("final.tasinmaTeklifi", "yakinTasin", .bold,
                    tr: "Taşın, yakın ol",
                    outcomes: [
                        outcome("final.tasinmaTeklifi", "yakinTasin", 1, w: 2,
                            tr: "Torunlar her gün uğruyor; ev yeniden kalabalık.",
                            fx: [hp(6), so(3)]),
                        outcome("final.tasinmaTeklifi", "yakinTasin", 2,
                            tr: "Yeni mahallede kimseyi tanımadın; eski sokak çok özlendi.",
                            fx: [hp(-6), so(-2)]),
                    ]),
            ]
        ),

        news(
            "final.emekliKahvesi", seasons: [.finalSezonu], w: 10, cd: .years(2),
            tr: "Kahvede masa hazır: aynı dört kişi, aynı tartışma, farklı sonuç yok.",
            fx: [so(3)]
        ),

        news(
            "final.dizFizigi", seasons: [.finalSezonu], from: 72, w: 10, cd: .years(3),
            tr: "Dizler hava değişimini önceden haber veriyor. Doktor 'yürümeye devam' dedi.",
            fx: [hl(-2), iq(1)]
        ),

        decision(
            "final.mirasKonusmasi", seasons: [.finalSezonu], from: 72, w: 8, cd: .years(6),
            tr: "Evrak işlerini konuşma vakti geldi. Kimse başlatmak istemiyor.",
            choices: [
                choice("final.mirasKonusmasi", "ertele", .safe,
                    tr: "Şimdi değil, sonra",
                    outcomes: [
                        outcome("final.mirasKonusmasi", "ertele", 1,
                            tr: "Akşam neşeli geçti. Bazı konuşmalar sırasını bekler.",
                            fx: [hp(2)]),
                    ]),
                choice("final.mirasKonusmasi", "konus", .bold,
                    tr: "Sofrada açıkça konuş",
                    outcomes: [
                        outcome("final.mirasKonusmasi", "konus", 1, w: 2,
                            tr: "Her şey netleşti; herkes rahatladı. En zor konuşma en iyi hediye oldu.",
                            fx: [hp(6), so(2)]),
                        outcome("final.mirasKonusmasi", "konus", 2,
                            tr: "Sofrada gerginlik oldu; bir hafta sonra düzeldi.",
                            fx: [hp(-6)]),
                    ]),
            ]
        ),

        news(
            "final.eskiMektuplar", seasons: [.finalSezonu], from: 70, w: 8, cd: .years(5),
            tr: "Bir kutu mektup bulundu. El yazıları tanıdık, tarihler çok eski, cümleler hâlâ taze.",
            fx: [hp(4)]
        ),

        news(
            "final.mahalleninAbisi", seasons: [.finalSezonu], w: 8, cd: .years(4),
            tr: "Sokakta çocuklar seni görünce selam veriyor. Adın 'amca' değil, kendi adın.",
            fx: [so(3), hp(2)]
        ),

        decision(
            "final.sonProje", seasons: [.finalSezonu], from: 68, w: 8, cd: .years(6),
            tr: "Aklında yıllardır duran bir iş var: yazmak, dikmek, kurmak — ne ise o.",
            choices: [
                choice("final.sonProje", "keyfine", .safe,
                    tr: "Keyfine göre, acele etmeden",
                    outcomes: [
                        outcome("final.sonProje", "keyfine", 1,
                            tr: "Yavaş yavaş ilerledi; her akşam biraz daha büyüdü.",
                            fx: [hp(3)]),
                    ]),
                choice("final.sonProje", "bitir", .bold,
                    tr: "Bu yıl bitir",
                    outcomes: [
                        outcome("final.sonProje", "bitir", 1, w: 2,
                            tr: "Bitti! Aile küçük bir tören yaptı; sen ilk kez 'tamamladım' dedin.",
                            fx: [hp(7), rol("tamamlayan", "İşini Bitiren")]),
                        outcome("final.sonProje", "bitir", 2,
                            tr: "Yarım kaldı; ama yarım kalan işin de bir güzelliği varmış.",
                            fx: [hp(-8)]),
                    ]),
            ]
        ),

        news(
            "final.torunlaMutfak", seasons: [.finalSezonu], w: 10, cond: [.hasFlag(.torunVar)], cd: .years(3),
            tr: "Torunla mutfakta hamur açıldı. Un her yere gitti, kimse temizliği düşünmedi.",
            fx: [hp(4), so(2)]
        ),

        news(
            "final.kissKitabi", seasons: [.finalSezonu], from: 70, w: 8, cd: .years(4),
            tr: "Kış boyunca okunacak kitaplar seçildi ve başucuna dizildi. Program hazır.",
            fx: [iq(2), hp(2)]
        ),

        news(
            "final.eskiKomsuZiyareti", seasons: [.finalSezonu], w: 8, cd: .years(4),
            tr: "Otuz yıl önceki komşun ziyarete geldi. İki saat isim isim herkesi andınız.",
            fx: [so(4), hp(2)]
        ),

        decision(
            "final.sagligaDikkat", seasons: [.finalSezonu], from: 75, w: 10, cd: .years(4),
            tr: "Doktor yeni bir düzen önerdi: ilaç saatleri, yürüyüş, erken uyku.",
            choices: [
                choice("final.sagligaDikkat", "uygula", .safe,
                    tr: "Harfiyen uygula",
                    outcomes: [
                        outcome("final.sagligaDikkat", "uygula", 1,
                            tr: "Rakamlar düzeldi; doktor bir dahaki kontrolde memnun kaldı.",
                            fx: [hl(4)]),
                    ]),
                choice("final.sagligaDikkat", "kendiUsul", .neutral,
                    tr: "Kendi usulünce ayarla",
                    outcomes: [
                        outcome("final.sagligaDikkat", "kendiUsul", 1,
                            tr: "Bazı maddeler tutuldu, bazıları esnetildi. Hayat da böyle.",
                            fx: [hl(1), hp(2)]),
                    ]),
            ]
        ),

        news(
            "final.pencereManzarasi", seasons: [.finalSezonu], w: 10, cd: .years(2),
            tr: "Pencere kenarındaki koltuk artık en sevilen yer. Sokak oradan iyi görünüyor.",
            fx: [hp(3)]
        ),

        news(
            "final.ailePortresi", seasons: [.finalSezonu], from: 70, w: 8, cond: [.hasFlag(.cocukVar)], cd: .years(6),
            tr: "Bütün aile bir araya gelip fotoğraf çektirdi. Duvarda en büyük çerçeve onun oldu.",
            fx: [hp(5), so(3)]
        ),
    ]
}
