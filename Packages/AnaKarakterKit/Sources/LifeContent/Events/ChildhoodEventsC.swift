import LifeDomain

/// Çocukluk (0–5) — Faz 4 içerik genişlemesi.
/// Yaş bantları zorunlu: bu sezonda gelişim basamağı yıl yıl değişir.
enum ChildhoodEventsC {
    static let all: [LifeEvent] = [

        news(
            "cocukluk.ilkBanyo", seasons: [.cocukluk], to: 2, w: 10,
            tr: "Küvette ördek filosu göreve başladı. Banyo on dakika, kurulanma yarım saat sürdü.",
            fx: [hp(2)]
        ),

        news(
            "cocukluk.uykuSarkisi", seasons: [.cocukluk], to: 3, w: 10, cd: .years(2),
            tr: "Aynı ninni yine söylendi. Sözleri herkes karıştırıyor ama etkisi tartışılmaz.",
            fx: [hl(1), hp(2)]
        ),

        decision(
            "cocukluk.oyuncakPaylasimi", seasons: [.cocukluk], from: 3, w: 10,
            tr: "Misafir çocuk en sevdiğin oyuncağa uzandı. Salonda kısa bir sessizlik oldu.",
            choices: [
                choice("cocukluk.oyuncakPaylasimi", "paylas", .safe,
                    tr: "Ver, birlikte oynayın",
                    outcomes: [
                        outcome("cocukluk.oyuncakPaylasimi", "paylas", 1,
                            tr: "İkiniz de güldünüz; büyükler 'ne kadar olgun' diye fısıldadı.",
                            fx: [so(2)]),
                    ]),
                choice("cocukluk.oyuncakPaylasimi", "sahiplen", .bold,
                    tr: "Sarıl ve bırakma",
                    outcomes: [
                        outcome("cocukluk.oyuncakPaylasimi", "sahiplen", 1, w: 2,
                            tr: "Sınırını korudun; oyuncak senin kaldı, saygı da öyle.",
                            fx: [so(7)]),
                        outcome("cocukluk.oyuncakPaylasimi", "sahiplen", 2,
                            tr: "Kısa bir ağlama krizi; sonra ikiniz de aynı battaniyenin altında uyudunuz.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.mahalleBakkali", seasons: [.cocukluk], from: 4, w: 10, cd: .years(3),
            tr: "Bakkal amca vereside yazdı, üstüne bir şeker ekledi. Mahalle ekonomisi böyle işler.",
            fx: [hp(2), tl(100)]
        ),

        decision(
            "cocukluk.karTatili", seasons: [.cocukluk], from: 4, w: 10,
            tr: "Sabah camlar buz tuttu, sokak bembeyaz. İçeride mi, dışarıda mı?",
            choices: [
                choice("cocukluk.karTatili", "icerde", .safe,
                    tr: "Sobanın yanında kal",
                    outcomes: [
                        outcome("cocukluk.karTatili", "icerde", 1,
                            tr: "Camda buz desenleri, elde sıcak süt. Kış içeriden de güzelmiş.",
                            fx: [hl(2)]),
                    ]),
                choice("cocukluk.karTatili", "disarda", .bold,
                    tr: "Kardan adam kurulacak",
                    outcomes: [
                        outcome("cocukluk.karTatili", "disarda", 1, w: 2,
                            tr: "Sokağın en büyük kardan adamı sizin oldu; havucu komşu teyze verdi.",
                            fx: [hl(6)]),
                        outcome("cocukluk.karTatili", "disarda", 2,
                            tr: "Eldivenler ıslandı, burun kızardı; akşam öksürük nöbeti başladı.",
                            fx: [hl(-6)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.televizyonKusagi", seasons: [.cocukluk], from: 3, w: 10, cd: .years(2),
            tr: "Çizgi film kuşağı başladı; jenerik müziği evde herkesin diline dolandı.",
            fx: [hp(2)]
        ),

        news(
            "cocukluk.ilkKarne", seasons: [.cocukluk], from: 5, to: 5, w: 10,
            tr: "Anaokulundan 'katılım belgesi' geldi. Buzdolabı kapağı ilk madalyasını taktı.",
            fx: [hp(2), iq(1)]
        ),

        decision(
            "cocukluk.hayvanKorkusu", seasons: [.cocukluk], from: 3, w: 10,
            tr: "Sokağın köpeği yolunu kesti. Kuyruğu sallanıyor ama boyu senden büyük.",
            choices: [
                choice("cocukluk.hayvanKorkusu", "elTut", .safe,
                    tr: "Annenin elini sıkı tut",
                    outcomes: [
                        outcome("cocukluk.hayvanKorkusu", "elTut", 1,
                            tr: "Yavaşça geçtiniz; köpek arkanızdan baktı, sen de bir kez döndün.",
                            fx: [hp(1), hl(1)]),
                    ]),
                choice("cocukluk.hayvanKorkusu", "yaklas", .bold,
                    tr: "Elini uzat, tanış",
                    outcomes: [
                        outcome("cocukluk.hayvanKorkusu", "yaklas", 1, w: 2,
                            tr: "Elini yaladı! O günden sonra sokakta iki dostun var: biri dört ayaklı.",
                            fx: [hp(6)]),
                        outcome("cocukluk.hayvanKorkusu", "yaklas", 2,
                            tr: "Havlayınca zıpladın; korku bir hafta sürdü, sonra geçti.",
                            fx: [hp(-6)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.balkonCicegi", seasons: [.cocukluk], from: 4, w: 8, cd: .years(3),
            tr: "Balkondaki saksıya senin adına bir fide dikildi. Sulama görevi resmen sende.",
            fx: [hp(2), hl(1)]
        ),

        decision(
            "cocukluk.dogumGunuPastasi", seasons: [.cocukluk], from: 3, w: 10, cd: .years(3),
            tr: "Pastanın mumları yandı. Herkes bekliyor: dilek ne olacak?",
            choices: [
                choice("cocukluk.dogumGunuPastasi", "sirla", .neutral,
                    tr: "Kimseye söyleme",
                    outcomes: [
                        outcome("cocukluk.dogumGunuPastasi", "sirla", 1,
                            tr: "Sır sende kaldı; gülümsemenden bir şey anlaşılmadı (belki biraz anlaşıldı).",
                            fx: [hp(3)]),
                    ]),
                choice("cocukluk.dogumGunuPastasi", "bagir", .neutral,
                    tr: "Bağıra bağıra söyle",
                    outcomes: [
                        outcome("cocukluk.dogumGunuPastasi", "bagir", 1,
                            tr: "Salon kahkahaya boğuldu; dilek tutulmadı ama gece unutulmadı.",
                            fx: [so(3)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.cizimDuvari", seasons: [.cocukluk], from: 2, to: 4, w: 10,
            tr: "Koridor duvarı sanat galerisine dönüştü. Sanatçı memnun, boya masrafı belirsiz.",
            fx: [hp(3), iq(1)]
        ),

        decision(
            "cocukluk.marketReyonu", seasons: [.cocukluk], from: 4, w: 10,
            tr: "Markette çikolata reyonuna denk geldiniz. Elin çoktan uzandı bile.",
            choices: [
                choice("cocukluk.marketReyonu", "izinIste", .safe,
                    tr: "Önce izin iste",
                    outcomes: [
                        outcome("cocukluk.marketReyonu", "izinIste", 1,
                            tr: "'Bir tane' dendi, iki tane alındı. Diplomasi kazandı.",
                            fx: [hp(2)]),
                    ]),
                choice("cocukluk.marketReyonu", "sepeteKoy", .bold,
                    tr: "Sessizce sepete koy",
                    outcomes: [
                        outcome("cocukluk.marketReyonu", "sepeteKoy", 1, w: 2,
                            tr: "Kasada fark edildi ama gülünüp geçildi; çikolata da geçti.",
                            fx: [hp(6)]),
                        outcome("cocukluk.marketReyonu", "sepeteKoy", 2,
                            tr: "Reyona geri kondu. Ders: sepet herkesin görebildiği bir yerdir.",
                            fx: [hp(-6)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.aileArabasi", seasons: [.cocukluk], from: 2, w: 10, cd: .years(3),
            tr: "Uzun yol: arka koltukta uyku, radyoda eski şarkılar, molada gazoz.",
            fx: [hp(2)]
        ),

        news(
            "cocukluk.komsuCocugu", seasons: [.cocukluk], from: 3, w: 12, cd: .years(4),
            tr: "Karşı daireye yaşıtın taşındı. İki gün içinde ayrılmaz ikili oldunuz.",
            fx: [so(4)]
        ),

        decision(
            "cocukluk.saklambac", seasons: [.cocukluk], from: 4, w: 10,
            tr: "Saklambaç başladı. Perde arkası herkesin bildiği yer, dolap ise riskli.",
            choices: [
                choice("cocukluk.saklambac", "perde", .safe,
                    tr: "Perde arkası — klasik",
                    outcomes: [
                        outcome("cocukluk.saklambac", "perde", 1,
                            tr: "Hemen bulundun ama oyun uzun sürdü; asıl mesele koşmaktı zaten.",
                            fx: [so(2)]),
                    ]),
                choice("cocukluk.saklambac", "dolap", .bold,
                    tr: "Dolabın en dibi",
                    outcomes: [
                        outcome("cocukluk.saklambac", "dolap", 1, w: 2,
                            tr: "Kimse bulamadı! Efsane olarak anlatıldı, sen de biraz uyudun.",
                            fx: [so(7)]),
                        outcome("cocukluk.saklambac", "dolap", 2,
                            tr: "Kapı üstüne kapandı; iki dakika sonra kurtarıldın, herkes koşturdu.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.bayramSabahi", seasons: [.cocukluk], from: 3, w: 12, cd: .years(2),
            tr: "Bayram sabahı: yeni ayakkabı ciyaklıyor, kolonya kokuyor, herkes gülümsüyor.",
            fx: [hp(3), so(2)]
        ),
    ]
}
