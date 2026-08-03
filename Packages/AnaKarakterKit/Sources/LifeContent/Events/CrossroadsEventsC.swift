import LifeDomain

/// Yol Ayrımı (18–24) — Faz 4 içerik genişlemesi.
/// İlk özgürlük, ilk fatura, ilk "kendi kararım".
enum CrossroadsEventsC {
    static let all: [LifeEvent] = [

        news(
            "yol.ilkValiz", seasons: [.yolAyrimi], to: 20, w: 12,
            tr: "Valiz kapandı. Annen üç kez açıp bir şeyler daha koydu; kapı önünde kimse konuşamadı.",
            fx: [hp(2), so(1)]
        ),

        decision(
            "yol.evArkadasi", seasons: [.yolAyrimi], from: 19, w: 10,
            tr: "Ev arkadaşın bulaşıkları üç gündür bekletiyor. Mutfak sabrını sınıyor.",
            choices: [
                choice("yol.evArkadasi", "kendinYika", .safe,
                    tr: "Sessizce sen yıka",
                    outcomes: [
                        outcome("yol.evArkadasi", "kendinYika", 1,
                            tr: "Mutfak temiz, huzur yerinde. Bazı savaşlar verilmez.",
                            fx: [hp(2)]),
                    ]),
                choice("yol.evArkadasi", "konus", .bold,
                    tr: "Otur konuş, kural koy",
                    outcomes: [
                        outcome("yol.evArkadasi", "konus", 1, w: 2,
                            tr: "Nöbet çizelgesi buzdolabına asıldı; ev bir anda düzene girdi.",
                            fx: [so(7)]),
                        outcome("yol.evArkadasi", "konus", 2,
                            tr: "Konuşma tatsız bitti; iki hafta 'günaydın' bile zor söylendi.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "yol.ilkFatura", seasons: [.yolAyrimi], from: 19, w: 12, cd: .years(2),
            tr: "İlk elektrik faturası geldi. Rakama üç kez bakıldı, sonra lamba söndürüldü.",
            fx: [tl(-5_000), iq(1)]
        ),

        decision(
            "yol.gecelikCalisma", seasons: [.yolAyrimi], from: 19, w: 10,
            tr: "Vize haftası. Kütüphane 24 saat açık, kahve makinesi bozuk.",
            choices: [
                choice("yol.gecelikCalisma", "planli", .safe,
                    tr: "Programa yay, erken yat",
                    outcomes: [
                        outcome("yol.gecelikCalisma", "planli", 1,
                            tr: "Sınavlara dinlenmiş girdin; notlar beklendiği gibi geldi.",
                            fx: [iq(2)]),
                    ]),
                choice("yol.gecelikCalisma", "sabahla", .bold,
                    tr: "Sabaha kadar tek oturuşta",
                    outcomes: [
                        outcome("yol.gecelikCalisma", "sabahla", 1, w: 2,
                            tr: "Beynin son gece açıldı; iki dersten en yüksek notu aldın.",
                            fx: [iq(6)]),
                        outcome("yol.gecelikCalisma", "sabahla", 2,
                            tr: "Sınavda ilk yarım saat uyuklandı. Vücut faturayı kesti.",
                            fx: [iq(-6)]),
                    ]),
            ]
        ),

        news(
            "yol.ilkTaziye", seasons: [.yolAyrimi], from: 20, w: 8,
            tr: "Uzak bir akraba vefat etti. Aile telefonda; sen ilk kez 'başın sağ olsun' diyen taraftasın.",
            fx: [hp(-3), so(2)]
        ),

        decision(
            "yol.tezKonusu", seasons: [.yolAyrimi], from: 21, w: 10,
            tr: "Bitirme projesi konusu seçilecek. Danışman iki liste uzattı: kolay ve zor.",
            choices: [
                choice("yol.tezKonusu", "kolay", .safe,
                    tr: "Kolay listeden seç",
                    outcomes: [
                        outcome("yol.tezKonusu", "kolay", 1,
                            tr: "Zamanında bitti, savunma sakin geçti. İş gördü.",
                            fx: [iq(2)]),
                    ]),
                choice("yol.tezKonusu", "zor", .bold,
                    tr: "Zor olanı iste",
                    outcomes: [
                        outcome("yol.tezKonusu", "zor", 1, w: 2,
                            tr: "Jüri 'bunu yayınlayalım' dedi. Adın bir yerde daha geçecek.",
                            fx: [iq(6)]),
                        outcome("yol.tezKonusu", "zor", 2,
                            tr: "Bir dönem uzadı. Öğrendiğin çok, uykun az oldu.",
                            fx: [iq(-6)]),
                    ]),
            ]
        ),

        news(
            "yol.kutuphaneGecesi", seasons: [.yolAyrimi], from: 19, w: 8, cd: .years(3),
            tr: "Kütüphane kapanış anonsu yapıldı; masadaki üç kişi hâlâ aynı soruya bakıyor.",
            fx: [iq(2), so(1)]
        ),

        decision(
            "yol.ilkKira", seasons: [.yolAyrimi], from: 20, w: 10,
            tr: "Kira artışı geldi. Ev güzel ama bütçe artık zorlanıyor.",
            choices: [
                choice("yol.ilkKira", "kal", .safe,
                    tr: "Kal, kemer sık",
                    outcomes: [
                        outcome("yol.ilkKira", "kal", 1,
                            tr: "Dışarıda yemek azaldı, ev sıcaklığı kaldı.",
                            fx: [tl(-20_000), hp(2)]),
                    ]),
                choice("yol.ilkKira", "tasin", .bold,
                    tr: "Daha ucuza taşın",
                    outcomes: [
                        outcome("yol.ilkKira", "tasin", 1, w: 2,
                            tr: "Yeni mahalle beklenenden iyi çıktı; hem ucuz hem canlı.",
                            fx: [tl(40_000), so(2)]),
                        outcome("yol.ilkKira", "tasin", 2,
                            tr: "Taşınma masrafı tasarrufu yedi; üstelik ısınma sorunu çıktı.",
                            fx: [tl(-80_000), hl(-2)]),
                    ]),
            ]
        ),

        news(
            "yol.ilkOyKullanma", seasons: [.yolAyrimi], from: 18, w: 10,
            tr: "Sandık başına ilk kez gittin. Kuyrukta komşularla sohbet, çıkışta ıslak parmak.",
            fx: [so(2), iq(1)]
        ),

        decision(
            "yol.yurtdisiFirsati", seasons: [.yolAyrimi], from: 20, w: 8,
            tr: "Bir dönemlik değişim programı ilanı asıldı. Başvuru için üç gün var.",
            choices: [
                choice("yol.yurtdisiFirsati", "kalayim", .safe,
                    tr: "Bu sefer kal",
                    outcomes: [
                        outcome("yol.yurtdisiFirsati", "kalayim", 1,
                            tr: "Dönemi burada tamamladın; düzenin bozulmadı.",
                            fx: [iq(2)]),
                    ]),
                choice("yol.yurtdisiFirsati", "basvur", .bold,
                    tr: "Başvur, ne olacaksa olsun",
                    outcomes: [
                        outcome("yol.yurtdisiFirsati", "basvur", 1, w: 2,
                            tr: "Kabul geldi! Bir dönem başka bir dilde uyandın; dünya büyüdü.",
                            fx: [iq(6), so(2)]),
                        outcome("yol.yurtdisiFirsati", "basvur", 2,
                            tr: "Liste açıklandı, adın yoktu. Başvurmuş olmak yine de bir şeydi.",
                            fx: [iq(-6)]),
                    ]),
            ]
        ),

        news(
            "yol.mahalleyeDonus", seasons: [.yolAyrimi], from: 19, w: 10, cd: .years(2),
            tr: "Tatilde mahalleye döndün; bakkal seni tanıdı, sokak küçülmüş gibi geldi.",
            fx: [hp(3), so(2)]
        ),

        decision(
            "yol.ilkMulakat", seasons: [.yolAyrimi], from: 22, w: 12,
            tr: "İlk ciddi mülakat. Kravat bağlandı, sorular beklenenden farklı.",
            choices: [
                choice("yol.ilkMulakat", "ezberi", .safe,
                    tr: "Hazırladığın cevapları ver",
                    outcomes: [
                        outcome("yol.ilkMulakat", "ezberi", 1,
                            tr: "Temiz bir görüşme oldu; 'sizi ararız' cümlesi bu kez gerçekti.",
                            fx: [so(2)]),
                    ]),
                choice("yol.ilkMulakat", "durustce", .bold,
                    tr: "Bilmediğine bilmiyorum de",
                    outcomes: [
                        outcome("yol.ilkMulakat", "durustce", 1, w: 2,
                            tr: "'Bunu takdir ettik' dediler; teklif ertesi gün geldi.",
                            fx: [so(7)]),
                        outcome("yol.ilkMulakat", "durustce", 2,
                            tr: "Dürüstlük bu masada karşılık bulmadı. Başka masa var.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "yol.mezuniyetToreni", seasons: [.yolAyrimi], from: 22, w: 10,
            tr: "Kep havaya atıldı. Tribünde birileri senin adını bağırdı; duydun.",
            fx: [hp(4), so(2), rol("mezun", "Diplomalı")]
        ),

        decision(
            "yol.ilkKrediKarti", seasons: [.yolAyrimi], from: 21, w: 10,
            tr: "Bankadan kart teklifi geldi: limit yüksek, taksit cazip.",
            choices: [
                choice("yol.ilkKrediKarti", "reddet", .safe,
                    tr: "Nazikçe reddet",
                    outcomes: [
                        outcome("yol.ilkKrediKarti", "reddet", 1,
                            tr: "Cüzdanın sade kaldı; ay sonu sürprizi de yok.",
                            fx: [tl(20_000)]),
                    ]),
                choice("yol.ilkKrediKarti", "al", .bold,
                    tr: "Al, kontrollü kullanırım",
                    outcomes: [
                        outcome("yol.ilkKrediKarti", "al", 1, w: 2,
                            tr: "Kontrol gerçekten sağlandı; puanlarla bir uçak bileti bile çıktı.",
                            fx: [tl(60_000)]),
                        outcome("yol.ilkKrediKarti", "al", 2,
                            tr: "Asgari ödeme tuzağı bir yıl sürdü; ders sert ama öğretici oldu.",
                            fx: [tl(-60_000)]),
                    ]),
            ]
        ),

        news(
            "yol.tasinmaGunu", seasons: [.yolAyrimi], from: 19, w: 8, cd: .years(3),
            tr: "Taşınma günü: iki arkadaş, bir kamyonet, dört kat merdiven. Akşam pizza ısmarlandı.",
            fx: [so(3), hl(-1), tl(-3_000)]
        ),

        decision(
            "yol.ilkTatilPlani", seasons: [.yolAyrimi], from: 20, w: 10, cd: .years(3),
            tr: "Arkadaşlarla ilk 'bizim' tatil planlanıyor. Bütçe belirsiz, heves yüksek.",
            choices: [
                choice("yol.ilkTatilPlani", "yakin", .safe,
                    tr: "Yakın bir yere, kısa bir tatil",
                    outcomes: [
                        outcome("yol.ilkTatilPlani", "yakin", 1,
                            tr: "Üç gün, temiz hava, doğru bütçe. Herkes memnun döndü.",
                            fx: [hp(2), tl(-10_000)]),
                    ]),
                choice("yol.ilkTatilPlani", "uzak", .bold,
                    tr: "Uzak rota, uzun yol",
                    outcomes: [
                        outcome("yol.ilkTatilPlani", "uzak", 1, w: 2,
                            tr: "Yıllarca anlatılacak bir tatil oldu; fotoğraflar hâlâ kullanılıyor.",
                            fx: [hp(6), tl(-30_000)]),
                        outcome("yol.ilkTatilPlani", "uzak", 2,
                            tr: "Otobüs bozuldu, plan dağıldı; dönüşte kimse konuşmak istemedi.",
                            fx: [hp(-6), tl(-30_000)]),
                    ]),
            ]
        ),

        news(
            "yol.ilkAbonelik", seasons: [.yolAyrimi], from: 20, w: 8, cd: .years(4),
            tr: "Üç abonelikten ikisi unutulmuş. Ay sonu hesabı bir arkeoloji çalışmasına döndü.",
            fx: [tl(-4_000), iq(1)]
        ),

        decision(
            "yol.gonulluKamp", seasons: [.yolAyrimi], from: 19, w: 8,
            tr: "Bir dernek yaz kampına gönüllü arıyor: iki hafta, ücret yok, çocuklar var.",
            choices: [
                choice("yol.gonulluKamp", "gitme", .safe,
                    tr: "Bu yaz çalış",
                    outcomes: [
                        outcome("yol.gonulluKamp", "gitme", 1,
                            tr: "Cebe para girdi; yaz sakin ve verimli geçti.",
                            fx: [tl(20_000)]),
                    ]),
                choice("yol.gonulluKamp", "git", .bold,
                    tr: "Git, iki hafta ver",
                    outcomes: [
                        outcome("yol.gonulluKamp", "git", 1, w: 2,
                            tr: "Otuz çocuk adını öğrendi; dönüşte bambaşka biri oldun.",
                            fx: [so(6), tl(20_000), flag(.gonullu)]),
                        outcome("yol.gonulluKamp", "git", 2,
                            tr: "Kamp zordu, hastalandın; yine de pişman değilsin.",
                            fx: [hl(-6), tl(20_000)]),
                    ]),
            ]
        ),

        news(
            "yol.ilkOfis", seasons: [.yolAyrimi], from: 22, w: 10,
            tr: "İlk ofis günü: masan pencereye uzak, kahve makinesi yakın. Dengeler kuruldu.",
            fx: [so(2), iq(1)]
        ),

        news(
            "yol.eskiOgretmen", seasons: [.yolAyrimi], from: 20, w: 8, cd: .years(5),
            tr: "Sokakta eski öğretmenine rastladın; adını hatırladı ve halini sordu.",
            fx: [hp(3)]
        ),

        decision(
            "yol.muzikGrubu", seasons: [.yolAyrimi], from: 19, w: 8, cd: .years(4),
            tr: "Arkadaşlar bir grup kuruyor. Prova yeri bulundu, bir kişi eksik.",
            choices: [
                choice("yol.muzikGrubu", "dinleyici", .safe,
                    tr: "Dinleyici kal",
                    outcomes: [
                        outcome("yol.muzikGrubu", "dinleyici", 1,
                            tr: "Her provaya gittin; grubun resmî fotoğrafçısı oldun.",
                            fx: [so(2)]),
                    ]),
                choice("yol.muzikGrubu", "katil", .bold,
                    tr: "Sahneye çık",
                    outcomes: [
                        outcome("yol.muzikGrubu", "katil", 1, w: 2,
                            tr: "İlk konserde salon doldu; adın afişte küçük ama vardı.",
                            fx: [so(7), flag(.sahneAski)]),
                        outcome("yol.muzikGrubu", "katil", 2,
                            tr: "Prova saatleri dersleri yedi; grup iki ay sonra dağıldı.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "yol.ilkBirikim", seasons: [.yolAyrimi], from: 22, w: 8, cd: .years(3),
            tr: "Hesapta ilk kez dokunulmayan bir rakam var. Küçük ama senin.",
            fx: [tl(15_000), hp(2)]
        ),

        news(
            "yol.mahalleDugunu", seasons: [.yolAyrimi], from: 19, w: 8, cd: .years(4),
            tr: "Mahalle düğününde halaya çekildin. Ayak uyduramadın ama kimse aldırmadı.",
            fx: [so(3), hp(2)]
        ),
    ]
}
