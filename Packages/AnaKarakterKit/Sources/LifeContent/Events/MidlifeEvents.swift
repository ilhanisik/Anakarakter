import LifeDomain

/// Orta Sahne (40–64): zirve/kriz, sağlık uyarıları, dönüş biletleri.
enum MidlifeEvents {
    static let all: [LifeEvent] = [

        decision(
            "orta.saglikUyarisi", seasons: [.ortaSahne], w: 12, cd: .years(5),
            tr: "Rutin kontrol. Doktor tahlillere baktı: 'Kötü değil ama biraz dikkat edelim.'",
            choices: [
                choice("orta.saglikUyarisi", "duzen", .safe,
                    tr: "Ciddiye al; düzeni değiştir",
                    outcomes: [
                        outcome("orta.saglikUyarisi", "duzen", 1,
                            tr: "Yürüyüş, uyku, ölçülü sofra. Tahliller de yüzün de güldü.",
                            fx: [hl(6), hp(-1)]),
                    ]),
                choice("orta.saglikUyarisi", "takip", .neutral,
                    tr: "Takibe al; kontrolü aksatma",
                    outcomes: [
                        outcome("orta.saglikUyarisi", "takip", 1,
                            tr: "Düzenli takip iyi geldi; doktorunla ilk isimle selamlaşma seviyesindesiniz.",
                            fx: [hl(2)]),
                    ]),
            ]
        ),

        decision(
            "orta.kariyerZirvesi", seasons: [.ortaSahne], w: 10,
            cond: [.hasFlag(.calisiyor)],
            tr: "Sektörden büyük teklif geldi: unvan parlak, tempo acımasız.",
            choices: [
                choice("orta.kariyerZirvesi", "koltuk", .safe,
                    tr: "Konforlu koltuğunda kal",
                    outcomes: [
                        outcome("orta.kariyerZirvesi", "koltuk", 1,
                            tr: "İşini biliyorsun, seviyorlar; akşam yemeğine hep yetişiyorsun.",
                            fx: [hp(3)]),
                    ]),
                choice("orta.kariyerZirvesi", "kabul", .bold,
                    tr: "Kabul et",
                    outcomes: [
                        outcome("orta.kariyerZirvesi", "kabul", 1,
                            tr: "Unvan da geldi, saygı da. Sektör panellerinde artık sen konuşuyorsun.",
                            fx: [tl(50_000), so(4), hl(-2), rol("zirve", "Zirve dönemi")]),
                        outcome("orta.kariyerZirvesi", "kabul", 2,
                            tr: "Unvan güzel, uyku kayıp. Telefon gece de susmuyor.",
                            fx: [tl(20_000), hp(-4), hl(-3)]),
                    ]),
            ]
        ),

        news(
            "orta.cocukOkul", seasons: [.ortaSahne], w: 10,
            cond: [.hasFlag(.cocukVar)], cd: .years(4),
            tr: "Veli toplantısı. Öğretmen çocuğun için 'çok enerjik' dedi; tercümesi hepimizde saklı.",
            fx: [hp(2), so(1)]
        ),

        decision(
            "orta.kankaDugunu", seasons: [.kurulus, .ortaSahne], w: 10,
            cond: [.hasFlag(.kanka)],
            tr: "İlkokuldan kankan evleniyor. Masanızda eski defterler açılıyor; mikrofon ortada dolaşıyor.",
            choices: [
                choice("orta.kankaDugunu", "otur", .safe,
                    tr: "Takımını giy, güzelce otur",
                    outcomes: [
                        outcome("orta.kankaDugunu", "otur", 1,
                            tr: "Şık bir gece; fotoğraflarda hep gülen taraftasın.",
                            fx: [so(2)]),
                    ]),
                choice("orta.kankaDugunu", "mikrofon", .bold,
                    tr: "Mikrofonu kap, o efsane anıyı anlat",
                    outcomes: [
                        outcome("orta.kankaDugunu", "mikrofon", 1, w: 2,
                            tr: "Salon gülmekten yıkıldı; damat/gelin masasından ayakta alkış.",
                            fx: [so(7), rol("dugunMikrofoncusu", "Düğünlerin mikrofoncusu")]),
                        outcome("orta.kankaDugunu", "mikrofon", 2,
                            tr: "Anının sonunu yanlış hatırlıyormuşsun; kankan kıpkırmızı, sen daha kırmızı.",
                            fx: [so(-6)]),
                    ]),
            ]
        ),

        decision(
            "orta.memleketFikri", seasons: [.ortaSahne], w: 10,
            tr: "İçinde bir ses büyüyor: 'Memlekete dönsek mi?' Bahçe fotoğrafları kaydedilmeye başlandı.",
            choices: [
                choice("orta.memleketFikri", "kal", .safe,
                    tr: "Şehirde kal",
                    outcomes: [
                        outcome("orta.memleketFikri", "kal", 1,
                            tr: "Düzenin burada, dostların burada. Bahçe özlemi saksılarla giderildi.",
                            fx: [hp(1)]),
                    ]),
                choice("orta.memleketFikri", "don", .bold,
                    tr: "Dön; bahçeli ev, sakin hayat",
                    outcomes: [
                        outcome("orta.memleketFikri", "don", 1,
                            tr: "Sabahlar kuş sesli, domates kendi bahçenden. İyi ki dedin.",
                            fx: [hp(6), hl(2), tl(-20_000)]),
                        outcome("orta.memleketFikri", "don", 2,
                            tr: "İki ayda sıkıldın; herkes 'demiştim' dedi. Sen yine de denedin.",
                            fx: [hp(-5)]),
                    ]),
            ]
        ),

        decision(
            "orta.hobi", seasons: [.ortaSahne], w: 10, cd: .years(5),
            tr: "Eller boş durmuyor; yeni bir uğraş arıyorsun.",
            choices: [
                choice("orta.hobi", "ahsap", .neutral,
                    tr: "Ahşap işleri",
                    outcomes: [
                        outcome("orta.hobi", "ahsap", 1,
                            tr: "İlk tabure biraz yamuk ama 'el emeği' bunun adı. Ev atölye koktu.",
                            fx: [hp(3), flag(.hobiUstasi)]),
                    ]),
                choice("orta.hobi", "koro", .neutral,
                    tr: "Mahalle korosu",
                    outcomes: [
                        outcome("orta.hobi", "koro", 1,
                            tr: "Perşembe akşamları artık kutsal; sesin de fena değilmiş.",
                            fx: [so(3)]),
                    ]),
                choice("orta.hobi", "balkon", .neutral,
                    tr: "Balkon bahçeciliği",
                    outcomes: [
                        outcome("orta.hobi", "balkon", 1,
                            tr: "Fesleğen, domates, bir de nazar için biber. Balkon yeşillendi.",
                            fx: [hp(2), hl(1)]),
                    ]),
            ]
        ),

        decision(
            "orta.ebeveynBakimi", seasons: [.ortaSahne], w: 10,
            tr: "Annenle baban artık daha sık arıyor; seslerinde tatlı bir yorgunluk var.",
            choices: [
                choice("orta.ebeveynBakimi", "ziyaret", .neutral,
                    tr: "Haftalık ziyaret düzeni kur",
                    outcomes: [
                        outcome("orta.ebeveynBakimi", "ziyaret", 1,
                            tr: "Pazar kahvaltıları geri geldi; en çok da sen iyileştin.",
                            fx: [hp(3), so(2), rol("evlat", "Evlat gibi evlat")]),
                    ]),
                choice("orta.ebeveynBakimi", "yakin", .neutral,
                    tr: "Yakınına taşınmalarını öner",
                    outcomes: [
                        outcome("orta.ebeveynBakimi", "yakin", 1,
                            tr: "İki sokak öteye taşındılar; çorba tenceresi iki yönlü işliyor.",
                            fx: [hp(2), so(1)]),
                    ]),
            ]
        ),

        news(
            "orta.sinifBulusmasi", seasons: [.ortaSahne], w: 8,
            cond: [.hasFlag(.kanka)],
            tr: "30 yıl sonra sınıf buluşması: kimse değişmemiş, herkes değişmiş. Lakaplar aynen yerinde.",
            fx: [so(4), hp(2)]
        ),

        decision(
            "orta.platoVeYeniden", seasons: [.ortaSahne], w: 10,
            cond: [.hasFlag(.calisiyor)],
            tr: "İş rutine bağlandı; her gün aynı filmin tekrarı gibi.",
            choices: [
                choice("orta.platoVeYeniden", "rutin", .safe,
                    tr: "Rutin iyidir; enerjiyi hobiye sakla",
                    outcomes: [
                        outcome("orta.platoVeYeniden", "rutin", 1,
                            tr: "İş sakin, akşamlar dolu. Denge de bir başarıdır.",
                            fx: [hp(2)]),
                    ]),
                choice("orta.platoVeYeniden", "alanDegistir", .bold,
                    tr: "Alan değiştir; sıfırdan öğren",
                    outcomes: [
                        outcome("orta.platoVeYeniden", "alanDegistir", 1,
                            tr: "Kursu bitirdin, alan değişti; 'bu yaştan sonra' diyenlere selam olsun.",
                            fx: [iq(5), hp(2), rol("yenidenBaslayan", "Yeniden başlayan")]),
                        outcome("orta.platoVeYeniden", "alanDegistir", 2,
                            tr: "Kurs paraları gitti, kararsızlık kaldı. En azından artık ne istemediğini biliyorsun.",
                            fx: [hp(-4), tl(-10_000)]),
                    ]),
            ]
        ),

        // AKE sahne olayı
        decision(
            "sahne.orta.sahneyeDonus", seasons: [.ortaSahne], w: 8,
            cond: [.minStat(.ake, 70)],
            tr: "SAHNE SENİN: Belediyenin amatör tiyatrosu oyuncu arıyor. İçindeki ışık hiç sönmemişti zaten.",
            choices: [
                choice("sahne.orta.sahneyeDonus", "don", .bold,
                    tr: "Sahneye dön",
                    outcomes: [
                        outcome("sahne.orta.sahneyeDonus", "don", 1, w: 2,
                            tr: "Prömiyerde ön sıra ailene ayrıldı. Perde kapanınca ilk kalkan onlardı.",
                            fx: [hp(6), so(3), rol("ikinciPerde", "İkinci perde")]),
                        outcome("sahne.orta.sahneyeDonus", "don", 2,
                            tr: "Sahnede kostüm dikişi söküldü; gülüşmeler alkışa döndü, oyun devam etti.",
                            fx: [hp(1)]),
                    ]),
                choice("sahne.orta.sahneyeDonus", "seyirci", .neutral,
                    tr: "Seyirci koltuğundan destekle",
                    outcomes: [
                        outcome("sahne.orta.sahneyeDonus", "seyirci", 1,
                            tr: "Her oyunda ön sıradasın; ekip seni 'şansımız' ilan etti.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),
    ]
}
