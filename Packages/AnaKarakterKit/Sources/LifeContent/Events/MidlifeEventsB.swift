import LifeDomain

/// Orta Sahne (40–64) — Faz 2 genişletmesi.
enum MidlifeEventsB {
    static let all: [LifeEvent] = [

        decision(
            "orta.gencMentor", seasons: [.ortaSahne], from: 45, w: 10,
            cond: [.hasFlag(.calisiyor)],
            tr: "İşe yeni giren genç, gözünü sana dikti: 'Bir şey sorabilir miyim?' günde beş kez.",
            choices: [
                choice("orta.gencMentor", "mentor", .neutral,
                    tr: "Mentoru ol",
                    outcomes: [
                        outcome("orta.gencMentor", "mentor", 1,
                            tr: "Bildiklerini aktardıkça kendi ustalığını fark ettin; genç uçtu, sen gururlandın.",
                            fx: [so(3), rol("usta", "Ustalardan biri")]),
                    ]),
                choice("orta.gencMentor", "mesafe", .neutral,
                    tr: "Nazik bir mesafe koru",
                    outcomes: [
                        outcome("orta.gencMentor", "mesafe", 1,
                            tr: "Herkes kendi yolunu yürür; sen yine de kritik anda bir kahve ısmarladın.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),

        decision(
            "orta.genclikHevesi", seasons: [.ortaSahne], w: 10,
            tr: "Dolabın dibinde duran eski heves (gitar, fırça, ne ise o) bugün göz kırptı.",
            choices: [
                choice("orta.genclikHevesi", "dursun", .safe,
                    tr: "Yerinde dursun; anılar tozlanmasın",
                    outcomes: [
                        outcome("orta.genclikHevesi", "dursun", 1,
                            tr: "Kapağı kapattın ama gülümseyerek; belki başka bahara.",
                            fx: [hp(1)]),
                    ]),
                choice("orta.genclikHevesi", "yeniden", .bold,
                    tr: "Yeniden başla",
                    outcomes: [
                        outcome("orta.genclikHevesi", "yeniden", 1, w: 2,
                            tr: "Parmaklar hatırladı! Cuma akşamları ev konseri geleneği başladı.",
                            fx: [hp(5)]),
                        outcome("orta.genclikHevesi", "yeniden", 2,
                            tr: "Nasır ve nostalji; iki hafta sonra duvardaki yerine geri döndü.",
                            fx: [hp(-2)]),
                    ]),
            ]
        ),

        news(
            "orta.saglikliMutfak", seasons: [.ortaSahne], w: 10, cd: .years(4),
            tr: "Evde zeytinyağlı dönemi başladı; yeni tarifler denendi, tencereler onayladı.",
            fx: [hl(2), hp(1)]
        ),

        news(
            "orta.arkadasKampi", seasons: [.ortaSahne], w: 8,
            cond: [.hasFlag(.kanka)], cd: .years(4),
            tr: "Eski ekiple doğa kampı: çadır yamuk kuruldu, ateş geç yandı, muhabbet kusursuzdu.",
            fx: [so(3), hp(2)]
        ),

        decision(
            "orta.evEkonomisi", seasons: [.ortaSahne], w: 10, cd: .years(4),
            tr: "Ev bütçesi masaya yatırıldı: tablo açık, kalem hazır, çay demli.",
            choices: [
                choice("orta.evEkonomisi", "tasarruf", .neutral,
                    tr: "Küçük tasarruf turu başlat",
                    outcomes: [
                        outcome("orta.evEkonomisi", "tasarruf", 1,
                            tr: "Abonelik temizliği + liste ile pazar: ay sonunda fark görünür oldu.",
                            fx: [tl(10_000), iq(1)]),
                    ]),
                choice("orta.evEkonomisi", "boyleIyi", .neutral,
                    tr: "Böyle iyi; huzur da bütçe kalemi",
                    outcomes: [
                        outcome("orta.evEkonomisi", "boyleIyi", 1,
                            tr: "Tabloyu kapatıp baklava aldınız; bazı yatırımlar anlıktır.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),

        decision(
            "orta.kutuphaneBagisi", seasons: [.ortaSahne], w: 8,
            cond: [.hasFlag(.kitapKurdu)],
            tr: "Kitaplıktaki koleksiyon iki sıra derinliğe ulaştı; okul kütüphanesinin listesi geldi aklına.",
            choices: [
                choice("orta.kutuphaneBagisi", "bagisla", .neutral,
                    tr: "Bir kısmını okul kütüphanesine bağışla",
                    outcomes: [
                        outcome("orta.kutuphaneBagisi", "bagisla", 1,
                            tr: "Kitapların yeni okurları oldu; içlerinden birine adını yazan bir çocuk var.",
                            fx: [hp(3), rol("kitapDostu", "Kitap dostu")]),
                    ]),
                choice("orta.kutuphaneBagisi", "kalsin", .neutral,
                    tr: "Koleksiyon bütün kalsın",
                    outcomes: [
                        outcome("orta.kutuphaneBagisi", "kalsin", 1,
                            tr: "Raflar senin hikâyen; tozunu alırken her cilt bir anı fısıldadı.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),

        decision(
            "orta.komsuGurultu", seasons: [.ortaSahne], w: 10, cd: .years(4),
            tr: "Üst kata yeni komşu taşındı; 'ev düzenleme' mesaisi gece 23.00'te başlıyor.",
            choices: [
                choice("orta.komsuGurultu", "sabret", .safe,
                    tr: "Yastıkla sabret",
                    outcomes: [
                        outcome("orta.komsuGurultu", "sabret", 1,
                            tr: "İki hafta sonra sesler kesildi; kulaklık da fena icat değilmiş.",
                            fx: [hp(-1)]),
                    ]),
                choice("orta.komsuGurultu", "kapiCal", .bold,
                    tr: "Tatlı dille kapısını çal",
                    outcomes: [
                        outcome("orta.komsuGurultu", "kapiCal", 1, w: 2,
                            tr: "Baklava eşliğinde anlaşma: sessizlik + yeni bir dost kazanıldı.",
                            fx: [so(3), hp(1)]),
                        outcome("orta.komsuGurultu", "kapiCal", 2,
                            tr: "Kapı sohbeti nezaket turnuvasına dönüştü; sonuç: beraberlik.",
                            fx: [so(-1)]),
                    ]),
            ]
        ),

        decision(
            "orta.terfiSunumu", seasons: [.ortaSahne], to: 60, w: 10,
            cond: [.hasFlag(.calisiyor)],
            tr: "Terfi listesinde adın var; yanında bir de gencecik, pırıl pırıl bir rakip.",
            choices: [
                choice("orta.terfiSunumu", "dosya", .safe,
                    tr: "Dosyanı sessizce güçlendir",
                    outcomes: [
                        outcome("orta.terfiSunumu", "dosya", 1,
                            tr: "Rakamlar senin yerine konuştu; saygın bir aday oldun.",
                            fx: [iq(2)]),
                    ]),
                choice("orta.terfiSunumu", "sahne", .bold,
                    tr: "Genel sunumda sahneyi al",
                    outcomes: [
                        outcome("orta.terfiSunumu", "sahne", 1,
                            tr: "Sunum günlerce konuşuldu; terfi ve tebrik mesajları peş peşe geldi.",
                            fx: [so(4), tl(20_000)]),
                        outcome("orta.terfiSunumu", "sahne", 2,
                            tr: "Projeksiyon arıza yaptı; genç rakip nazikçe kabloyu uzattı. Zor gündü.",
                            fx: [so(-4)]),
                    ]),
            ]
        ),

        news(
            "orta.eskiSokak", seasons: [.ortaSahne], w: 8, cd: .years(5),
            tr: "Yolun düştü, büyüdüğün sokağı gezdin. Ağaç kocaman olmuş, kapı küçücük kalmış.",
            fx: [hp(2)]
        ),

        news(
            "orta.cocukUniversite", seasons: [.ortaSahne], from: 45, w: 8,
            cond: [.hasFlag(.cocukVar)],
            tr: "Çocuğun üniversiteyi kazandı; valiz bagajda, gözyaşı peronda, gurur her yerde.",
            fx: [hp(4), tl(-20_000)]
        ),

        decision(
            "orta.plakKoleksiyonu", seasons: [.ortaSahne], w: 8, cd: .years(5),
            tr: "Eski şarkılar peşinden geldi: plak/kaset kutusu yeniden gündemde.",
            choices: [
                choice("orta.plakKoleksiyonu", "bitPazari", .neutral,
                    tr: "Bit pazarı turlarına başla",
                    outcomes: [
                        outcome("orta.plakKoleksiyonu", "bitPazari", 1,
                            tr: "Pazarcıyla dost oldun; her hafta bir hazine, bir hikâye.",
                            fx: [hp(2), tl(-3_000)]),
                    ]),
                choice("orta.plakKoleksiyonu", "dijital", .neutral,
                    tr: "Dijital arşiv kur",
                    outcomes: [
                        outcome("orta.plakKoleksiyonu", "dijital", 1,
                            tr: "Listeler tarihe göre dizildi; aile yolculuklarının müziği artık senden.",
                            fx: [iq(1), hp(1)]),
                    ]),
            ]
        ),

        decision(
            "orta.veteranTurnuvasi", seasons: [.ortaSahne], from: 45, w: 8,
            cond: [.hasFlag(.sporcuRuh)],
            tr: "Mahallede veteranlar turnuvası kuruluyor; eski forma hâlâ dolapta.",
            choices: [
                choice("orta.veteranTurnuvasi", "tribunLideri", .safe,
                    tr: "Tribün lideri ol",
                    outcomes: [
                        outcome("orta.veteranTurnuvasi", "tribunLideri", 1,
                            tr: "Tezahürat senin komutandaydı; takım sahaya bir kişi fazla çıktı sanki.",
                            fx: [so(2)]),
                    ]),
                choice("orta.veteranTurnuvasi", "sahayaCik", .bold,
                    tr: "Formayı giy, sahaya çık",
                    outcomes: [
                        outcome("orta.veteranTurnuvasi", "sahayaCik", 1, w: 2,
                            tr: "İki gol attın; dizler ertesi gün konuştu ama değdi.",
                            fx: [so(4), hp(1), hl(-1)]),
                        outcome("orta.veteranTurnuvasi", "sahayaCik", 2,
                            tr: "Beşinci dakikada kas tutuldu; sahayı alkışlarla terk ettin.",
                            fx: [hl(-3), so(1)]),
                    ]),
            ]
        ),
    ]
}
