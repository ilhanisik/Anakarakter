import LifeDomain

/// Kuruluş (25–39) — Faz 4 içerik genişlemesi.
/// Kariyer, ev, ilişki ve "yetişkinlik" faturalarının sezonu.
enum FoundationEventsC {
    static let all: [LifeEvent] = [

        decision(
            "kurulus.mesaiSaatleri", seasons: [.kurulus], w: 10, cd: .years(4),
            tr: "Proje teslimi yaklaşıyor; ekip akşamları kalmaya başladı.",
            choices: [
                choice("kurulus.mesaiSaatleri", "sinirKoy", .safe,
                    tr: "Saatinde çık, sınırını koru",
                    outcomes: [
                        outcome("kurulus.mesaiSaatleri", "sinirKoy", 1,
                            tr: "Akşamların sana kaldı; iş de bir şekilde yetişti.",
                            fx: [hl(2)]),
                    ]),
                choice("kurulus.mesaiSaatleri", "kal", .bold,
                    tr: "Sonuna kadar kal",
                    outcomes: [
                        outcome("kurulus.mesaiSaatleri", "kal", 1, w: 2,
                            tr: "Teslim kusursuzdu; yönetim adını not etti.",
                            fx: [hl(6)]),
                        outcome("kurulus.mesaiSaatleri", "kal", 2,
                            tr: "Üç hafta sonunda tükendin; bir hafta izin şart oldu.",
                            fx: [hl(-6)]),
                    ]),
            ]
        ),

        news(
            "kurulus.ilkTakimYemegi", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "Ekip yemeğinde herkesin bir hikâyesi çıktı; masada iş konuşulmadı, iyi geldi.",
            fx: [so(3)]
        ),

        decision(
            "kurulus.saglikKontrolu", seasons: [.kurulus], from: 30, w: 10, cd: .years(5),
            tr: "İş yeri check-up hakkı tanıdı. Randevu almak iki dakika, gitmek başka mesele.",
            choices: [
                choice("kurulus.saglikKontrolu", "git", .safe,
                    tr: "Randevuya git",
                    outcomes: [
                        outcome("kurulus.saglikKontrolu", "git", 1,
                            tr: "Sonuçlar iyi çıktı; doktor 'böyle devam' dedi.",
                            fx: [hl(3)]),
                    ]),
                choice("kurulus.saglikKontrolu", "ertele", .neutral,
                    tr: "Yoğunluk geçsin, sonra",
                    outcomes: [
                        outcome("kurulus.saglikKontrolu", "ertele", 1,
                            tr: "Takvim doldu, hak kullanılmadı. Gelecek yıl yine hatırlanacak.",
                            fx: [hl(-1)]),
                    ]),
            ]
        ),

        news(
            "kurulus.eskiArkadasTelefonu", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "Yıllardır görüşmediğin biri aradı. Yarım saat sonra hiç ayrılmamış gibiydiniz.",
            fx: [so(3), hp(2)]
        ),

        decision(
            "kurulus.ikinciDil", seasons: [.kurulus], w: 8, cd: .years(5),
            tr: "Akşam kursu ilanı gördün: haftada iki gün, bir yıl.",
            choices: [
                choice("kurulus.ikinciDil", "vazgec", .safe,
                    tr: "Şimdilik vazgeç",
                    outcomes: [
                        outcome("kurulus.ikinciDil", "vazgec", 1,
                            tr: "Takvim rahat kaldı; fikir defterde bekliyor.",
                            fx: [hp(2)]),
                    ]),
                choice("kurulus.ikinciDil", "yazil", .bold,
                    tr: "Yazıl, bir yıl ver",
                    outcomes: [
                        outcome("kurulus.ikinciDil", "yazil", 1, w: 2,
                            tr: "Bir yıl sonunda bir filmi altyazısız izledin. Kapılar açıldı.",
                            fx: [iq(6)]),
                        outcome("kurulus.ikinciDil", "yazil", 2,
                            tr: "Üçüncü aydan sonra devam edemedin; ücret yandı.",
                            fx: [iq(-6)]),
            ]),
            ]
        ),

        news(
            "kurulus.evTadilati", seasons: [.kurulus], cond: [.hasFlag(.evSahibi)], cd: .years(5),
            tr: "Boya kokusu bir hafta çıkmadı ama salon bambaşka oldu.",
            fx: [hp(3), tl(-40_000)]
        ),

        decision(
            "kurulus.isDegisikligi", seasons: [.kurulus], from: 28, w: 10,
            cond: [.hasFlag(.calisiyor)],
            tr: "Başka bir şirketten teklif geldi: maaş iyi, ekip belirsiz.",
            choices: [
                choice("kurulus.isDegisikligi", "kal", .safe,
                    tr: "Bildiğin masada kal",
                    outcomes: [
                        outcome("kurulus.isDegisikligi", "kal", 1,
                            tr: "Düzenin korundu; yıl sonunda küçük bir zam geldi.",
                            fx: [tl(20_000)]),
                    ]),
                choice("kurulus.isDegisikligi", "gec", .bold,
                    tr: "Teklifi kabul et",
                    outcomes: [
                        outcome("kurulus.isDegisikligi", "gec", 1, w: 2,
                            tr: "Yeni yer sana yaradı; iki yılda bir kademe atladın.",
                            fx: [tl(60_000)]),
                        outcome("kurulus.isDegisikligi", "gec", 2,
                            tr: "Ekip tutmadı; altı ay sonra yeniden iş aramaya başladın.",
                            fx: [tl(-60_000)]),
                    ]),
            ]
        ),

        news(
            "kurulus.kahveDukkani", seasons: [.kurulus], w: 8, cd: .years(3),
            tr: "Mahallede yeni bir kahveci açıldı; barista adını üçüncü gelişte öğrendi.",
            fx: [hp(2), tl(-2_000)]
        ),

        decision(
            "kurulus.aileZiyareti", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "Anne baba 'bir uğrasan' dedi. Hafta sonu zaten dolu.",
            choices: [
                choice("kurulus.aileZiyareti", "telefon", .safe,
                    tr: "Uzun bir telefon et",
                    outcomes: [
                        outcome("kurulus.aileZiyareti", "telefon", 1,
                            tr: "Kırk dakika konuştunuz; sesin duyulması da bir ziyaret.",
                            fx: [so(2)]),
                    ]),
                choice("kurulus.aileZiyareti", "git", .bold,
                    tr: "Planı iptal et, git",
                    outcomes: [
                        outcome("kurulus.aileZiyareti", "git", 1, w: 2,
                            tr: "Kapıyı açtıklarında yüzlerindeki ifade her şeye değdi.",
                            fx: [so(7)]),
                        outcome("kurulus.aileZiyareti", "git", 2,
                            tr: "Yolda trafiğe kaldın, ancak akşam yetiştin; yine de gittin.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "kurulus.ilkYatirimTavsiyesi", seasons: [.kurulus], from: 30, w: 8, cd: .years(5),
            tr: "Bir tanıdık 'kaçırma' dedi. Sen hesabına baktın ve gülümseyip geçtin.",
            fx: [iq(2)]
        ),

        decision(
            "kurulus.komsuAnlasmazligi", seasons: [.kurulus], w: 8, cd: .years(5),
            tr: "Apartman toplantısında aidat tartışması büyüdü. Herkes sana bakıyor.",
            choices: [
                choice("kurulus.komsuAnlasmazligi", "sus", .safe,
                    tr: "Karışma, dinle",
                    outcomes: [
                        outcome("kurulus.komsuAnlasmazligi", "sus", 1,
                            tr: "Toplantı bitti, kimse küsmedi. Sessizlik de bir katkıdır.",
                            fx: [hp(2)]),
                    ]),
                choice("kurulus.komsuAnlasmazligi", "cozum", .bold,
                    tr: "Ortak bir çözüm öner",
                    outcomes: [
                        outcome("kurulus.komsuAnlasmazligi", "cozum", 1, w: 2,
                            tr: "Öneri kabul edildi; artık apartmanın 'akil insanı' sensin.",
                            fx: [so(7), flag(.iyiKomsu)]),
                        outcome("kurulus.komsuAnlasmazligi", "cozum", 2,
                            tr: "İki taraf da sana kızdı. Arabuluculuk bazen böyle biter.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "kurulus.haftaSonuKahvaltisi", seasons: [.kurulus], w: 10, cd: .years(2),
            tr: "Cumartesi kahvaltısı üç saat sürdü; masadan kimse kalkmak istemedi.",
            fx: [hp(3), so(2)]
        ),

        news(
            "kurulus.yeniTelefon", seasons: [.kurulus], w: 8, cd: .years(5),
            tr: "Telefon değişti; eski fotoğrafların aktarımı iki akşam sürdü ve nostaljiyle bitti.",
            fx: [hp(2), tl(-25_000)]
        ),

        decision(
            "kurulus.sporSaliBaslangici", seasons: [.kurulus], from: 30, w: 10, cd: .years(4),
            tr: "Merdiven çıkarken nefes daraldı. Bir karar anı geldi.",
            choices: [
                choice("kurulus.sporSaliBaslangici", "yuruyus", .safe,
                    tr: "Günde yarım saat yürü",
                    outcomes: [
                        outcome("kurulus.sporSaliBaslangici", "yuruyus", 1,
                            tr: "Üç ay sonra merdiven sorun olmaktan çıktı.",
                            fx: [hl(3)]),
                    ]),
                choice("kurulus.sporSaliBaslangici", "salon", .bold,
                    tr: "Salona yazıl, ciddi başla",
                    outcomes: [
                        outcome("kurulus.sporSaliBaslangici", "salon", 1, w: 2,
                            tr: "Altı ayda form değişti; eski pantolonlar geri döndü.",
                            fx: [hl(7), tl(-15_000)]),
                        outcome("kurulus.sporSaliBaslangici", "salon", 2,
                            tr: "İlk ay hevesli, ikinci ay yok. Üyelik ücreti öğretmen oldu.",
                            fx: [hl(-8), tl(-15_000)]),
                    ]),
            ]
        ),

        news(
            "kurulus.dogaYuruyusu", seasons: [.kurulus], w: 8, cd: .years(4),
            tr: "Hafta sonu doğa yürüyüşü: çamur, termos, kahkaha ve dizlerde sızı.",
            fx: [hl(2), so(2)]
        ),

        decision(
            "kurulus.gonulluIs", seasons: [.kurulus], w: 8, cd: .years(5),
            tr: "Mahalle derneği kış yardımı için gönüllü topluyor.",
            choices: [
                choice("kurulus.gonulluIs", "bagis", .safe,
                    tr: "Bağış yap, katılma",
                    outcomes: [
                        outcome("kurulus.gonulluIs", "bagis", 1,
                            tr: "Yardım ulaştı; senin adın listede yazmadı ama vicdanın rahat.",
                            fx: [hp(2), tl(-10_000)]),
                    ]),
                choice("kurulus.gonulluIs", "katil", .bold,
                    tr: "Sahaya in, çalış",
                    outcomes: [
                        outcome("kurulus.gonulluIs", "katil", 1, w: 2,
                            tr: "İki hafta sonunda mahallede tanımadığın kimse kalmadı.",
                            fx: [so(7), flag(.gonullu)]),
                        outcome("kurulus.gonulluIs", "katil", 2,
                            tr: "Organizasyon dağınıktı; emek boşa gitti gibi hissettin.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "kurulus.eskiFotograflar", seasons: [.kurulus], w: 8, cd: .years(5),
            tr: "Bir kutu eski fotoğraf çıktı. Gece yarısına kadar hepsi tek tek bakıldı.",
            fx: [hp(3)]
        ),

        news(
            "kurulus.isteTanisma", seasons: [.kurulus], w: 8, cond: [.hasFlag(.calisiyor)], cd: .years(4),
            tr: "Yeni gelen meslektaş ilk gün herkesin adını öğrendi; senin masana kahve bıraktı.",
            fx: [so(3)]
        ),

        decision(
            "kurulus.tasinmaKarari", seasons: [.kurulus], from: 30, w: 8,
            tr: "Şehrin öbür ucunda daha ferah bir ev var; iş yerine uzak.",
            choices: [
                choice("kurulus.tasinmaKarari", "yakinKal", .safe,
                    tr: "İşe yakın kal",
                    outcomes: [
                        outcome("kurulus.tasinmaKarari", "yakinKal", 1,
                            tr: "Sabahların rahat; ev küçük ama hayat düzenli.",
                            fx: [hl(2)]),
                    ]),
                choice("kurulus.tasinmaKarari", "ferahEv", .bold,
                    tr: "Ferah eve geç",
                    outcomes: [
                        outcome("kurulus.tasinmaKarari", "ferahEv", 1, w: 2,
                            tr: "Balkondan ağaç görünüyor; yol uzun ama akşamlar iyileşti.",
                            fx: [hl(6)]),
                        outcome("kurulus.tasinmaKarari", "ferahEv", 2,
                            tr: "Günde üç saat yolda geçiyor; ferahlık yorgunluğa yenildi.",
                            fx: [hl(-6)]),
                    ]),
            ]
        ),

        news(
            "kurulus.mutfakDenemesi", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "İnternetten bakılan tarif denendi. Sonuç: fotoğrafa benzemedi ama yendi.",
            fx: [hp(2)]
        ),

        news(
            "kurulus.arabaIlkYol", seasons: [.kurulus], w: 8, cond: [.hasFlag(.arabaVar)], cd: .years(4),
            tr: "İlk uzun yol: benzin dolu, çalma listesi hazır, cam yarım açık.",
            fx: [hp(3), tl(-5_000)]
        ),

        decision(
            "kurulus.yanProje", seasons: [.kurulus], w: 8, cd: .years(5),
            tr: "Aklındaki fikir gece uyutmuyor. Hafta sonlarını yiyecek ama...",
            choices: [
                choice("kurulus.yanProje", "erte", .safe,
                    tr: "Şimdilik defterde kalsın",
                    outcomes: [
                        outcome("kurulus.yanProje", "erte", 1,
                            tr: "Fikir bekliyor; sen dinlendin. İkisi de gerekliydi.",
                            fx: [hp(2)]),
                    ]),
                choice("kurulus.yanProje", "basla", .bold,
                    tr: "Hafta sonları başla",
                    outcomes: [
                        outcome("kurulus.yanProje", "basla", 1, w: 2,
                            tr: "Altı ay sonra ilk kullanıcın oldu; küçük ama gerçek bir şey.",
                            fx: [iq(6), flag(.girisimciRuh)]),
                        outcome("kurulus.yanProje", "basla", 2,
                            tr: "Proje yarım kaldı; öğrendiklerin kaldı.",
                            fx: [iq(-6)]),
                    ]),
            ]
        ),

        news(
            "kurulus.komsuCocuguBuyudu", seasons: [.kurulus], from: 33, w: 8, cd: .years(5),
            tr: "Karşı dairenin çocuğu üniversiteye gitmiş. 'Ne çabuk' cümlesi ilk kez senden çıktı.",
            fx: [hp(2)]
        ),

        news(
            "kurulus.kislikHazirlik", seasons: [.kurulus], w: 8, cd: .years(3),
            tr: "Kışlık hazırlık: kavanozlar dizildi, mutfak bir haftalığına fabrikaya döndü.",
            fx: [hp(2), so(2)]
        ),

        decision(
            "kurulus.davetReddi", seasons: [.kurulus], w: 8, cd: .years(4),
            tr: "Üst üste üçüncü davet. Enerjin bitti ama kırmak da istemiyorsun.",
            choices: [
                choice("kurulus.davetReddi", "git", .safe,
                    tr: "Yorgunluğa rağmen git",
                    outcomes: [
                        outcome("kurulus.davetReddi", "git", 1,
                            tr: "İyi ki gitmişsin; gecenin ortasında güzel bir sohbet çıktı.",
                            fx: [so(2)]),
                    ]),
                choice("kurulus.davetReddi", "reddet", .bold,
                    tr: "Dürüstçe reddet",
                    outcomes: [
                        outcome("kurulus.davetReddi", "reddet", 1, w: 2,
                            tr: "'Anlıyorum' dediler. Sınır koymak ilişkiyi bozmadı, güçlendirdi.",
                            fx: [hp(6)]),
                        outcome("kurulus.davetReddi", "reddet", 2,
                            tr: "Bir süre araya mesafe girdi; sonra düzeldi ama düşündürdü.",
                            fx: [hp(-6)]),
                    ]),
            ]
        ),

        news(
            "kurulus.ilkGriSac", seasons: [.kurulus], from: 33, w: 8,
            tr: "Aynada ilk gri tel. Uzun uzun bakıldı, sonra omuz silkildi.",
            fx: [hp(-1), iq(1)]
        ),

        news(
            "kurulus.mahalleFirini", seasons: [.kurulus], w: 8, cd: .years(3),
            tr: "Fırıncı sabah ekmeğini ayırmaya başladı. Küçük bir ayrıcalık, büyük bir aidiyet.",
            fx: [so(2), hp(2)]
        ),

        decision(
            "kurulus.kariyerMolasi", seasons: [.kurulus], from: 32, w: 8,
            cond: [.hasFlag(.calisiyor), .minMoney(150_000)],
            tr: "Bir mola fikri büyüyor: üç ay ara vermek, kafayı toplamak.",
            choices: [
                choice("kurulus.kariyerMolasi", "devam", .safe,
                    tr: "Devam et, mola sonra",
                    outcomes: [
                        outcome("kurulus.kariyerMolasi", "devam", 1,
                            tr: "Çark döndü; yorgunluk da döndü ama düzen bozulmadı.",
                            fx: [tl(20_000)]),
                    ]),
                choice("kurulus.kariyerMolasi", "molaVer", .bold,
                    tr: "Üç ay ara ver",
                    outcomes: [
                        outcome("kurulus.kariyerMolasi", "molaVer", 1, w: 2,
                            tr: "Döndüğünde kafan berraktı; ilk ay iki yıllık işi çıkardın.",
                            fx: [tl(60_000), hp(3)]),
                        outcome("kurulus.kariyerMolasi", "molaVer", 2,
                            tr: "Geri dönüş beklediğinden zor oldu; birikim eridi.",
                            fx: [tl(-60_000)]),
                    ]),
            ]
        ),

        news(
            "kurulus.eskiSarki", seasons: [.kurulus], w: 8, cd: .years(4),
            tr: "Radyoda çalan şarkı seni on beş yıl geriye götürdü; direksiyonda sesli söylendi.",
            fx: [hp(3)]
        ),

        news(
            "kurulus.dostZiyareti", seasons: [.kurulus], w: 10, cond: [.hasFlag(.kanka)], cd: .years(3),
            tr: "Kankan haber vermeden kapıya geldi. Buzdolabı boştu, gece yine de uzun sürdü.",
            fx: [so(4), hp(2)]
        ),

        news(
            "kurulus.isYerindeTakdir", seasons: [.kurulus], w: 8, cond: [.hasFlag(.calisiyor)], cd: .years(4),
            tr: "Toplantıda adın geçti: 'Bunu o çözdü.' Kısa bir cümle, uzun bir gün.",
            fx: [so(3), hp(2)]
        ),

        decision(
            "kurulus.emeklilikPlani", seasons: [.kurulus], from: 35, w: 8, cd: .years(5),
            tr: "Bir tanıdık 'bireysel emeklilik' anlattı. Rakamlar uzak, yıllar yakın.",
            choices: [
                choice("kurulus.emeklilikPlani", "sonra", .safe,
                    tr: "Şimdilik erteleme",
                    outcomes: [
                        outcome("kurulus.emeklilikPlani", "sonra", 1,
                            tr: "Bugünün rahatı korundu; yarın yine gündeme gelecek.",
                            fx: [hp(2)]),
                    ]),
                choice("kurulus.emeklilikPlani", "basla", .bold,
                    tr: "Küçük bir tutarla başla",
                    outcomes: [
                        outcome("kurulus.emeklilikPlani", "basla", 1, w: 2,
                            tr: "Yıllar sonra 'iyi ki' diyeceğin karar bugün alındı.",
                            fx: [tl(40_000)]),
                        outcome("kurulus.emeklilikPlani", "basla", 2,
                            tr: "Aylık kesinti bütçeyi zorladı; bir yıl sonra durduruldu.",
                            fx: [tl(-40_000)]),
                    ]),
            ]
        ),

        news(
            "kurulus.yeniKomsuKedisi", seasons: [.kurulus], w: 8, cond: [.hasFlag(.evcilDost)], cd: .years(4),
            tr: "Balkona bir kedi daha uğramaya başladı. Mama kabı sessizce ikiye çıkarıldı.",
            fx: [hp(3)]
        ),
    ]
}
