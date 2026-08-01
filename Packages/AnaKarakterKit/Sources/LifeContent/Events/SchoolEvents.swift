import LifeDomain

/// Okul (6–17): karne, teneffüs, harçlık, ilk kanka.
enum SchoolEvents {
    static let all: [LifeEvent] = [

        decision(
            "okul.karneGunu", seasons: [.okul], w: 12, cd: .years(2),
            tr: "Karne günü. Zarf elinde, eve giden yol bugün daha uzun.",
            choices: [
                choice("okul.karneGunu", "goster", .neutral,
                    tr: "Eve gidip olduğu gibi göster",
                    outcomes: [
                        outcome("okul.karneGunu", "goster", 1,
                            tr: "Takdir! Buzdolabının kapısında yeni bir eser sergileniyor.",
                            fx: [hp(4)]),
                        outcome("okul.karneGunu", "goster", 2,
                            tr: "Birkaç zayıf var. Kısa bir sessizlik, sonra 'seneye artık' toplantısı.",
                            fx: [hp(-3), iq(1)]),
                    ]),
                choice("okul.karneGunu", "anneanne", .safe,
                    tr: "Önce anneannenin yanında aç",
                    outcomes: [
                        outcome("okul.karneGunu", "anneanne", 1,
                            tr: "'Benim kuzum zaten çok zeki' kalkanı devrede. Krizsiz atlatıldı.",
                            fx: [hp(2)]),
                    ]),
            ]
        ),

        decision(
            "okul.tenefusMaci", seasons: [.okul], w: 10, cd: .years(3),
            tr: "Teneffüs maçı kuruluyor; kaptanlar takım seçiyor.",
            choices: [
                choice("okul.tenefusMaci", "yedek", .safe,
                    tr: "Yedek kulübesinden başla",
                    outcomes: [
                        outcome("okul.tenefusMaci", "yedek", 1,
                            tr: "Son beş dakika girdin, temiz bir pas verdin. Sağlam başlangıç.",
                            fx: [so(1)]),
                    ]),
                choice("okul.tenefusMaci", "kaptan", .bold,
                    tr: "Kaptanlığa talip ol",
                    outcomes: [
                        outcome("okul.tenefusMaci", "kaptan", 1,
                            tr: "Takımın maçı aldı; zafer senin taktiğine yazıldı.",
                            fx: [so(6)]),
                        outcome("okul.tenefusMaci", "kaptan", 2,
                            tr: "Takım dağıldı, gol yağmuru. Kaptanlık koltuğu dikenliymiş.",
                            fx: [so(-4)]),
                    ]),
            ]
        ),

        decision(
            "okul.sinifBaskanligi", seasons: [.okul], w: 10,
            tr: "Sınıf başkanlığı seçimi var. Vaatler uçuşuyor: 'Herkese uzun teneffüs!'",
            choices: [
                choice("okul.sinifBaskanligi", "secmen", .safe,
                    tr: "Oy veren tarafta kal",
                    outcomes: [
                        outcome("okul.sinifBaskanligi", "secmen", 1,
                            tr: "Oyunu kullandın, tarafını seçtin. Demokrasi tatlıdır.",
                            fx: [so(1)]),
                    ]),
                choice("okul.sinifBaskanligi", "aday", .bold,
                    tr: "Aday ol",
                    outcomes: [
                        outcome("okul.sinifBaskanligi", "aday", 1,
                            tr: "Seçildin! İlk icraat: tahta silme çizelgesine adalet.",
                            fx: [so(7), flag(.lider), rol("sinifBaskani", "Sınıfın başkanı")]),
                        outcome("okul.sinifBaskanligi", "aday", 2,
                            tr: "İki oyla kaybettin; biri kendi oyundu. Saygı duyuldu.",
                            fx: [so(-4)]),
                    ]),
            ]
        ),

        decision(
            "okul.harclikEkonomisi", seasons: [.okul], w: 10,
            tr: "Harçlık haftayı çıkarmıyor; kantindeki tost zamlandı.",
            choices: [
                choice("okul.harclikEkonomisi", "kumbara", .safe,
                    tr: "Kumbara sistemi kur",
                    outcomes: [
                        outcome("okul.harclikEkonomisi", "kumbara", 1,
                            tr: "Haftalık bütçe planı yapıldı. Küçük yaşta CFO enerjisi.",
                            fx: [tl(1_000), iq(1)]),
                    ]),
                choice("okul.harclikEkonomisi", "ticaret", .bold,
                    tr: "Sınıfa gofret satışı organize et",
                    outcomes: [
                        outcome("okul.harclikEkonomisi", "ticaret", 1, w: 2,
                            tr: "Stoklar eridi, ciro rekor kırdı. Okulun gayriresmî kantini sensin.",
                            fx: [tl(2_500), so(3)]),
                        outcome("okul.harclikEkonomisi", "ticaret", 2,
                            tr: "Müdür yardımcısına yakalandın; sermaye ve gofretler müsadere edildi.",
                            fx: [tl(-1_000), hp(-2)]),
                    ]),
            ]
        ),

        news(
            "okul.ilkKanka", seasons: [.okul], w: 14,
            tr: "Sıra arkadaşın değişti. Üçüncü teneffüste ortak düşman (matematik) sizi kanka yaptı.",
            fx: [so(4), flag(.kanka)]
        ),

        decision(
            "okul.kopyaKrizi", seasons: [.okul], w: 10,
            tr: "Sınavda yan sıradan kopya kağıdı uzatıldı. Hoca camdan dışarı bakıyor.",
            choices: [
                choice("okul.kopyaKrizi", "bildigin", .safe,
                    tr: "Alma; bildiğini yaz",
                    outcomes: [
                        outcome("okul.kopyaKrizi", "bildigin", 1,
                            tr: "Kendi cevapların, kendi notun. İçin rahat çıktın.",
                            fx: [iq(2)]),
                    ]),
                choice("okul.kopyaKrizi", "calistir", .neutral,
                    tr: "Kağıdı geri ver; akşam ona ders çalıştır",
                    outcomes: [
                        outcome("okul.kopyaKrizi", "calistir", 1,
                            tr: "İkiniz de dersi geçtiniz. Mahallede 'hoca' lakabı takıldı.",
                            fx: [so(2), iq(1)]),
                    ]),
            ]
        ),

        decision(
            "okul.okulTiyatrosu", seasons: [.okul], w: 10,
            tr: "Yıl sonu oyunu için seçmeler başladı. Perde kokusu koridora vurdu.",
            choices: [
                choice("okul.okulTiyatrosu", "dekor", .safe,
                    tr: "Dekor ekibine yazıl",
                    outcomes: [
                        outcome("okul.okulTiyatrosu", "dekor", 1,
                            tr: "Kartondan kale senin eserin; alkışın sessiz ortağısın.",
                            fx: [so(2)]),
                    ]),
                choice("okul.okulTiyatrosu", "basrol", .bold,
                    tr: "Başrol seçmelerine çık",
                    outcomes: [
                        outcome("okul.okulTiyatrosu", "basrol", 1,
                            tr: "Perde kapanırken salon ayakta. İlk sahne tozu yutuldu.",
                            fx: [so(8), flag(.sahneAski)]),
                        outcome("okul.okulTiyatrosu", "basrol", 2,
                            tr: "Repliğini unuttun; suflörle düet yaptınız. Yine de bitirdin.",
                            fx: [so(-5), hp(1)]),
                    ]),
            ]
        ),

        news(
            "okul.servisSoforu", seasons: [.okul], w: 10, cd: .years(4),
            tr: "Servis şoförü bugün de 'kestirmeden' gitti; kestirme 40 dakika sürdü. Arka koltuk muhabbeti tarihe geçti.",
            fx: [so(1)]
        ),

        decision(
            "okul.dersMiOyunMu", seasons: [.okul], w: 10, cd: .years(3),
            tr: "Yarın sınav var; ama konsolda dün çıkan oyun duruyor.",
            choices: [
                choice("okul.dersMiOyunMu", "ders", .safe,
                    tr: "Ders başına",
                    outcomes: [
                        outcome("okul.dersMiOyunMu", "ders", 1,
                            tr: "Konu bitti, notlar sağlam. Oyun hafta sonuna randevu aldı.",
                            fx: [iq(3)]),
                    ]),
                choice("okul.dersMiOyunMu", "birSaat", .bold,
                    tr: "'Bir saat oyun, sonra ders' (hepimiz biliyoruz)",
                    outcomes: [
                        outcome("okul.dersMiOyunMu", "birSaat", 1,
                            tr: "Saat 03.00: 'son bir bölüm' hâlâ sürüyor. Sabah pişmanlık menüde.",
                            fx: [hp(4), iq(-3)]),
                        outcome("okul.dersMiOyunMu", "birSaat", 2,
                            tr: "Şaşırtıcı gelişme: gerçekten bir saatte bıraktın ve yetiştirdin.",
                            fx: [hp(2), iq(1)]),
                    ]),
            ]
        ),

        decision(
            "okul.mahalleTurnuvasi", seasons: [.okul], w: 10,
            tr: "Mahalleler arası turnuva finali. Skor eşit, son dakika penaltısı sizde.",
            choices: [
                choice("okul.mahalleTurnuvasi", "tribun", .safe,
                    tr: "Tribünden var gücünle destek ol",
                    outcomes: [
                        outcome("okul.mahalleTurnuvasi", "tribun", 1,
                            tr: "Tezahürat koptu, kupa mahalleye geldi. Sesin üç gün kısık.",
                            fx: [so(2)]),
                    ]),
                choice("okul.mahalleTurnuvasi", "penalti", .bold,
                    tr: "Penaltıya sen talip ol",
                    outcomes: [
                        outcome("okul.mahalleTurnuvasi", "penalti", 1,
                            tr: "GOOOL! Omuzlarda taşındın; mahalle tarihine geçtin.",
                            fx: [so(7), rol("penaltici", "Penaltı kahramanı")]),
                        outcome("okul.mahalleTurnuvasi", "penalti", 2,
                            tr: "Üst direk... Yıllarca 'o direk olmasaydı' diye anılacak.",
                            fx: [so(-4), hp(1)]),
                    ]),
            ]
        ),

        // AKE sahne olayı — yüksek enerji, yüksek sahne.
        decision(
            "sahne.okul.yetenekGecesi", seasons: [.okul], w: 8,
            cond: [.minStat(.ake, 70)],
            tr: "SAHNE SENİN: Okulun yetenek gecesinde kapanış numarası boş kaldı. Herkes birbirine bakıyor; ışık sana dönüyor.",
            choices: [
                choice("sahne.okul.yetenekGecesi", "kapanis", .bold,
                    tr: "Kapanışı sen yap",
                    outcomes: [
                        outcome("sahne.okul.yetenekGecesi", "kapanis", 1, w: 2,
                            tr: "Gece senin adınla anıldı. Yıllıkta tam sayfa fotoğraf.",
                            fx: [so(8), hp(4), rol("yetenekGecesi", "Yetenek gecesinin yıldızı")]),
                        outcome("sahne.okul.yetenekGecesi", "kapanis", 2,
                            tr: "Mikrofon arızalandı; doğaçlama devam ettin. Alkış yine geldi.",
                            fx: [so(2)]),
                    ]),
                choice("sahne.okul.yetenekGecesi", "pas", .neutral,
                    tr: "Bu sefer pas",
                    outcomes: [
                        outcome("sahne.okul.yetenekGecesi", "pas", 1,
                            tr: "Seyirci koltuğundan güzel bir gece izledin.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),
    ]
}
