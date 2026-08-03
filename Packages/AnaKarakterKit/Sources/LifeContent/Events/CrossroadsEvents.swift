import LifeDomain

/// Yol Ayrımı (18–24): üniversite/çalışma, ilk aşk, bütçe maceraları.
enum CrossroadsEvents {
    static let all: [LifeEvent] = [

        news(
            "yol.devletYurdu", seasons: [.yolAyrimi], to: 21, w: 10,
            cond: [.hasFlag(.universiteli)],
            tr: "Devlet yurdunda ilk gece: beş kişi, bir çaydanlık, sabaha kadar muhabbet. Çaydanlık kardeşliği kuruldu.",
            fx: [so(3)]
        ),

        decision(
            "yol.ilkAsk", seasons: [.yolAyrimi], w: 14,
            cond: [.lacksFlag(.iliskide)],
            tr: "Kalbin garip çarpıyor: ilk aşk. Aynı otobüs, aynı durak, 'tesadüf' üstüne tesadüf.",
            choices: [
                choice("yol.ilkAsk", "uzaktan", .safe,
                    tr: "Uzaktan uzaktan idare et",
                    outcomes: [
                        outcome("yol.ilkAsk", "uzaktan", 1,
                            tr: "Bakışmalar edebiyat kitabı gibi; kimse ilk adımı atmadı ama günler güzeldi.",
                            fx: [hp(1)]),
                    ]),
                choice("yol.ilkAsk", "acil", .bold,
                    tr: "Açıl",
                    outcomes: [
                        outcome("yol.ilkAsk", "acil", 1,
                            tr: "Karşılık geldi! Durak artık buluşma noktası.",
                            fx: [hp(8), flag(.iliskide)]),
                        outcome("yol.ilkAsk", "acil", 2,
                            tr: "Nazikçe reddedildin. O günden beri şarkılar daha anlamlı.",
                            fx: [hp(-6), iq(1)]),
                    ]),
            ]
        ),

        decision(
            "yol.partTime", seasons: [.yolAyrimi], w: 10,
            tr: "Bütçe delik. Panoda part-time ilanları: 'esnek saat, dinamik ekip' (tercüme: yoğun hafta sonu).",
            choices: [
                choice("yol.partTime", "kafe", .neutral,
                    tr: "Kafede garsonluk",
                    outcomes: [
                        outcome("yol.partTime", "kafe", 1,
                            tr: "Tepsi taşıma seviyesi: usta. Bahşişler ve müdavim muhabbetleri cabası.",
                            fx: [tl(30_000), so(2)]),
                    ]),
                choice("yol.partTime", "anket", .neutral,
                    tr: "Dönemlik anket işi",
                    outcomes: [
                        outcome("yol.partTime", "anket", 1,
                            tr: "'İki dakikanızı alacağım' cümlesini bin kez kurdun. Sabır kası geliştirildi.",
                            fx: [tl(20_000), iq(1)]),
                    ]),
            ]
        ),

        decision(
            "yol.sehirDegisikligi", seasons: [.yolAyrimi], w: 10,
            tr: "Başka şehirden bir fırsat geldi. Valiz mi, konfor mu?",
            choices: [
                choice("yol.sehirDegisikligi", "kal", .safe,
                    tr: "Kal; düzenin bozulmasın",
                    outcomes: [
                        outcome("yol.sehirDegisikligi", "kal", 1,
                            tr: "Tanıdık sokaklar, tanıdık simitçi. Huzur da bir tercih.",
                            fx: [hp(2)]),
                    ]),
                choice("yol.sehirDegisikligi", "tasin", .bold,
                    tr: "Taşın; yeni şehir, yeni sen",
                    outcomes: [
                        outcome("yol.sehirDegisikligi", "tasin", 1,
                            tr: "Şehir sana kapılarını açtı; ilk ayda üç yeni dost, bir favori çay ocağı.",
                            fx: [so(6), hp(2)]),
                        outcome("yol.sehirDegisikligi", "tasin", 2,
                            tr: "İlk yıl zor geçti: yanlış otobüsler, tuzlu kiralar, uzak sesler.",
                            fx: [hp(-5), so(-1)]),
                    ]),
            ]
        ),

        decision(
            "yol.staj", seasons: [.yolAyrimi], from: 20, w: 10,
            cond: [.hasFlag(.universiteli), .lacksFlag(.stajYapti)],
            tr: "Staj dönemi. Bölümün anlaşmalı listesi güvenli; ama hayalindeki yerin kapısı da orada duruyor.",
            choices: [
                choice("yol.staj", "anlasmali", .safe,
                    tr: "Anlaşmalı kurumda staj",
                    outcomes: [
                        outcome("yol.staj", "anlasmali", 1,
                            tr: "Düzenli, öğretici, evrakı tam. CV'ye sağlam bir satır.",
                            fx: [iq(2), flag(.stajYapti)]),
                    ]),
                choice("yol.staj", "kapidan", .bold,
                    tr: "Hayalindeki yere kapıdan başvur",
                    outcomes: [
                        outcome("yol.staj", "kapidan", 1,
                            tr: "Cesaretin kapıyı açtı! 'Kapıdan gelen stajyer' diye anılıyorsun.",
                            fx: [iq(6), flag(.stajYapti), rol("kapidanStajyer", "Kapıdan giren stajyer")]),
                        outcome("yol.staj", "kapidan", 2,
                            tr: "Cevap bile gelmedi. Olsun; e-postan edebî değer taşıyor.",
                            fx: [hp(-4)]),
                    ]),
            ]
        ),

        decision(
            "yol.arkadasEvi", seasons: [.yolAyrimi], w: 10,
            tr: "Arkadaşlarla ev tutma planı dönüyor. Grup adı hazır, bütçe tablosu havada.",
            choices: [
                choice("yol.arkadasEvi", "aile", .safe,
                    tr: "Aile evinde/yurtta kal",
                    outcomes: [
                        outcome("yol.arkadasEvi", "aile", 1,
                            tr: "Sıcak yemek, temiz çamaşır, dolu buzdolabı. Konfor bölgesi diye buna denir.",
                            fx: [hp(2)]),
                    ]),
                choice("yol.arkadasEvi", "evArkadasi", .bold,
                    tr: "Ev arkadaşlığına atla",
                    outcomes: [
                        outcome("yol.arkadasEvi", "evArkadasi", 1,
                            tr: "Ev efsane: film geceleri, ortak makarna, kapı her gelene açık. Bütçe yaralı ama değer.",
                            fx: [so(5), tl(-20_000)]),
                        outcome("yol.arkadasEvi", "evArkadasi", 2,
                            tr: "Bulaşık savaşları başladı; buzdolabına isim etiketleri yapıştırıldı.",
                            fx: [so(-4)]),
                    ]),
            ]
        ),

        decision(
            "yol.ehliyet", seasons: [.yolAyrimi], to: 20, w: 10,
            cond: [.lacksFlag(.ehliyetVar)],
            tr: "Ehliyet zamanı. Direksiyon hocasının ayağı kendi tarafındaki pedala hiç bu kadar yakın olmamıştı.",
            choices: [
                choice("yol.ehliyet", "birDonem", .safe,
                    tr: "Bir dönem daha kursa devam",
                    outcomes: [
                        outcome("yol.ehliyet", "birDonem", 1,
                            tr: "Sakin sakin öğrendin; park sensörün artık içinde.",
                            fx: [tl(-5_000), iq(1)]),
                    ]),
                choice("yol.ehliyet", "sinav", .bold,
                    tr: "Sınava gir",
                    outcomes: [
                        outcome("yol.ehliyet", "sinav", 1, w: 2,
                            tr: "Geçtin! Şerit değiştirirken hâlâ dua ediyorsun ama ehliyet cepte.",
                            fx: [hp(3), tl(-2_000), flag(.ehliyetVar)]),
                        outcome("yol.ehliyet", "sinav", 2,
                            tr: "Park etabında elendin. Dubalar hâlâ rüyanda deviriliyor.",
                            fx: [hp(-3), tl(-2_000)]),
                    ]),
            ]
        ),

        decision(
            "yol.butceKrizi", seasons: [.yolAyrimi], w: 10, cd: .years(2),
            tr: "Ay sonu: cüzdanda üç kağıt, önünde iki hafta.",
            choices: [
                choice("yol.butceKrizi", "makarna", .neutral,
                    tr: "Makarna haftaları başlasın",
                    outcomes: [
                        outcome("yol.butceKrizi", "makarna", 1,
                            tr: "Beş malzemeyle yedi farklı yemek icat ettin. Yaratıcı mutfak dönemi.",
                            fx: [iq(1), tl(-2_000)]),
                    ]),
                choice("yol.butceKrizi", "eveDonus", .neutral,
                    tr: "Hafta sonu eve moral ve erzak turu",
                    outcomes: [
                        outcome("yol.butceKrizi", "eveDonus", 1,
                            tr: "Dönüşte valiz kavanoz dolu; annenin poşetleri fizik kurallarını esnetiyor.",
                            fx: [hp(2), tl(-3_000)]),
                    ]),
            ]
        ),

        decision(
            "yol.gonulluluk", seasons: [.yolAyrimi], w: 10,
            tr: "Mahalle derneği gönüllü arıyor: kitap toplama kampanyası.",
            choices: [
                choice("yol.gonulluluk", "katil", .neutral,
                    tr: "Katıl",
                    outcomes: [
                        outcome("yol.gonulluluk", "katil", 1,
                            tr: "Koliler doldu, raflar kuruldu. İyilik bulaşıcı çıktı.",
                            fx: [so(3), flag(.gonullu), rol("gonullu", "Mahalle gönüllüsü")]),
                    ]),
                choice("yol.gonulluluk", "vakitYok", .neutral,
                    tr: "Bu dönem vaktin yok",
                    outcomes: [
                        outcome("yol.gonulluluk", "vakitYok", 1,
                            tr: "Kendine dürüst bir 'hayır' dedin; takvimin sana teşekkür etti.",
                            fx: [iq(1)]),
                    ]),
            ]
        ),

        // AKE sahne olayı
        decision(
            "sahne.yol.acikMikrofon", seasons: [.yolAyrimi], w: 8,
            cond: [.minStat(.ake, 70)],
            tr: "SAHNE SENİN: Kampüs kafede açık mikrofon gecesi. Sunucu 'aramızda cesur biri var mı?' diye soruyor; herkes sana bakıyor.",
            choices: [
                choice("sahne.yol.acikMikrofon", "cik", .bold,
                    tr: "Çık ve dök içini",
                    outcomes: [
                        outcome("sahne.yol.acikMikrofon", "cik", 1, w: 2,
                            tr: "Salon önce sustu, sonra coştu. Gecenin keşfi ilan edildin.",
                            fx: [so(7), rol("acikMikrofon", "Açık mikrofonun keşfi")]),
                        outcome("sahne.yol.acikMikrofon", "cik", 2,
                            tr: "Sessiz salon, tek bir garip ıslık. Yine de çıktın ya, o mikrofonu tuttun ya.",
                            fx: [so(-3), hp(1)]),
                    ]),
                choice("sahne.yol.acikMikrofon", "dinle", .neutral,
                    tr: "Dinleyici kal",
                    outcomes: [
                        outcome("sahne.yol.acikMikrofon", "dinle", 1,
                            tr: "İyi bir dinleyici her sahnenin gizli kahramanıdır.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),
    ]
}
