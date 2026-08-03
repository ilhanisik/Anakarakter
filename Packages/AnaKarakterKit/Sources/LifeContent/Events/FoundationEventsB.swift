import LifeDomain

/// Kuruluş (25–39) — Faz 2 genişletmesi.
enum FoundationEventsB {
    static let all: [LifeEvent] = [

        decision(
            "kurulus.teknoIs", seasons: [.kurulus], w: 10,
            cond: [.hasFlag(.teknoMeraki), .hasFlag(.calisiyor)],
            tr: "Çocukluktaki bilgisayar merakın kapı çaldı: şirket içi yazılım ekibine geçiş fırsatı var.",
            choices: [
                choice("kurulus.teknoIs", "kal", .safe,
                    tr: "Mevcut rolünde kal",
                    outcomes: [
                        outcome("kurulus.teknoIs", "kal", 1,
                            tr: "Bildiğin işte derinleştin; huzur da bir kariyer planı.",
                            fx: [hp(2)]),
                    ]),
                choice("kurulus.teknoIs", "gec", .bold,
                    tr: "Geç — merak seni çağırıyor",
                    outcomes: [
                        outcome("kurulus.teknoIs", "gec", 1, w: 2,
                            tr: "Kod yazıyorsun ve seviyorsun; maaş bandı da yüzünü güldürdü.",
                            fx: [tl(30_000), hp(3)]),
                        outcome("kurulus.teknoIs", "gec", 2,
                            tr: "İlk aylar dik bir öğrenme eğrisi; hata mesajları rüyalarına girdi.",
                            fx: [hp(-4), iq(1)]),
                    ]),
            ]
        ),

        news(
            "kurulus.kahvaltiEkibi", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "Cumartesi kahvaltı ekibi kuruldu: serpme, demli çay ve üç saatlik dünya meseleleri çözümü.",
            fx: [so(3), hp(1)]
        ),

        decision(
            "kurulus.tatilPlani", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "Yıllık izin onaylandı. Masada iki plan: bilindik sahil mi, rotasız yol mu?",
            choices: [
                choice("kurulus.tatilPlani", "sahil", .safe,
                    tr: "Her yılki sakin sahil kasabası",
                    outcomes: [
                        outcome("kurulus.tatilPlani", "sahil", 1,
                            tr: "Aynı pansiyon, aynı deniz, sıfır sürpriz: tam şarj dönüş.",
                            fx: [hp(3), tl(-15_000)]),
                    ]),
                choice("kurulus.tatilPlani", "rotasiz", .bold,
                    tr: "Rotasız araba tatili",
                    outcomes: [
                        outcome("kurulus.tatilPlani", "rotasiz", 1, w: 2,
                            tr: "Haritasız günler, tabelasız sapaklar, unutulmaz duraklar.",
                            fx: [hp(6), tl(-20_000)]),
                        outcome("kurulus.tatilPlani", "rotasiz", 2,
                            tr: "Araba dağ yolunda küstü; tatilin son günü sanayide bitti.",
                            fx: [hp(-3), tl(-25_000)]),
                    ]),
            ]
        ),

        news(
            "kurulus.aileYemegi", seasons: [.kurulus], w: 10, cd: .years(2),
            tr: "Aile yemeğinde klasik soru turu: 'Ee, daha daha?' Sen gülümseyip böreğe uzandın.",
            fx: [so(2)]
        ),

        decision(
            "kurulus.uykuDuzeni", seasons: [.kurulus], w: 10, cd: .years(4),
            tr: "Sabahlar zor geçiyor; uyku düzeni masaya yatırıldı.",
            choices: [
                choice("kurulus.uykuDuzeni", "erken", .safe,
                    tr: "Erken yat, erken kalk düzenine geç",
                    outcomes: [
                        outcome("kurulus.uykuDuzeni", "erken", 1,
                            tr: "İki hafta direndin, sonra vücut teşekkür etti; sabahlar aydınlandı.",
                            fx: [hl(3)]),
                    ]),
                choice("kurulus.uykuDuzeni", "geceKusu", .neutral,
                    tr: "Gece kuşu kal; gece senin en verimli saatin",
                    outcomes: [
                        outcome("kurulus.uykuDuzeni", "geceKusu", 1,
                            tr: "Gece sessizliğinde harikalar yaratıyorsun; sabahlara selam söyle.",
                            fx: [hp(1), hl(-1)]),
                    ]),
            ]
        ),

        news(
            "kurulus.altinGunu", seasons: [.kurulus], w: 8,
            cond: [.hasFlag(.evli)], cd: .years(3),
            tr: "Evde altın günü kuruldu: hem mahalle muhabbeti hem kenara küçük birikim.",
            fx: [so(2), tl(5_000)]
        ),

        decision(
            "kurulus.arabaTamiri", seasons: [.kurulus], w: 10,
            cond: [.hasFlag(.arabaVar)], cd: .years(4),
            tr: "Arabadan 'tık tık' sesi geliyor; dinleyen herkes farklı teşhis koydu.",
            choices: [
                choice("kurulus.arabaTamiri", "yetkili", .safe,
                    tr: "Yetkili servise götür",
                    outcomes: [
                        outcome("kurulus.arabaTamiri", "yetkili", 1,
                            tr: "Fatura kabarık ama ses gitti; kahve de ikram ettiler.",
                            fx: [tl(-15_000), hp(2)]),
                    ]),
                choice("kurulus.arabaTamiri", "usta", .bold,
                    tr: "Mahalledeki ustaya güven",
                    outcomes: [
                        outcome("kurulus.arabaTamiri", "usta", 1, w: 2,
                            tr: "Usta eli değdi, çeyrek fiyata çözüldü; çay içmeden bırakmadı.",
                            fx: [tl(-4_000), hp(2)]),
                        outcome("kurulus.arabaTamiri", "usta", 2,
                            tr: "O ses gitti, başka ses geldi. Usta 'onu sonra hallederiz' dedi.",
                            fx: [tl(-8_000), hp(-2)]),
                    ]),
            ]
        ),

        news(
            "kurulus.komsuTamir", seasons: [.kurulus], w: 8,
            cond: [.hasFlag(.iyiKomsu)], cd: .years(3),
            tr: "Komşunun damlayan musluğunu tamir ettin; karşılığı bir tepsi su böreği ve ömürlük selam.",
            fx: [so(2), hp(1)]
        ),

        decision(
            "kurulus.pazarlikUstasi", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "Beyaz eşya lazım; mağazada 'bugüne özel son fiyat' tabelası seni bekliyor.",
            choices: [
                choice("kurulus.pazarlikUstasi", "etiket", .safe,
                    tr: "Etiket fiyatına al, uzatma",
                    outcomes: [
                        outcome("kurulus.pazarlikUstasi", "etiket", 1,
                            tr: "Hızlı ve temiz alışveriş; teslimat ertesi gün kapıda.",
                            fx: [tl(-20_000), hp(1)]),
                    ]),
                choice("kurulus.pazarlikUstasi", "pazarlik", .bold,
                    tr: "Pazarlık sahnesini aç",
                    outcomes: [
                        outcome("kurulus.pazarlikUstasi", "pazarlik", 1, w: 2,
                            tr: "'Müdürüme sorayım' seansı sonrası indirim + hediye set. Zafer senin.",
                            fx: [tl(-15_000), hp(2)]),
                        outcome("kurulus.pazarlikUstasi", "pazarlik", 2,
                            tr: "Pazarlık ters tepti; arkandaki sıra sabırsızlıkla alkış tuttu.",
                            fx: [tl(-20_000), hp(-1)]),
                    ]),
            ]
        ),

        news(
            "kurulus.sabahKosusu", seasons: [.kurulus], w: 8,
            cond: [.hasFlag(.sporcuRuh)], cd: .years(4),
            tr: "Sabah koşusu ekibi seni de aralarına kattı; park parkuru artık senin pistin.",
            fx: [hl(3)]
        ),

        news(
            "kurulus.isArkadasiVeda", seasons: [.kurulus], w: 8,
            cond: [.hasFlag(.calisiyor)], cd: .years(4),
            tr: "En sevdiğin iş arkadaşın başka şehre taşındı. Veda pastası tatlıydı, tadı buruktu.",
            fx: [hp(-2), so(1)]
        ),

        decision(
            "kurulus.balkonTadilat", seasons: [.kurulus], w: 8,
            cond: [.hasFlag(.evSahibi)],
            tr: "Balkon elden geçecek. İki yol var: usta çağır ya da 'ben yaparım' videoları.",
            choices: [
                choice("kurulus.balkonTadilat", "usta", .safe,
                    tr: "Ustaya yaptır",
                    outcomes: [
                        outcome("kurulus.balkonTadilat", "usta", 1,
                            tr: "Üç günde bitti, tertemiz oldu; çay servisi senden, işçilik ondan.",
                            fx: [tl(-25_000), hp(3)]),
                    ]),
                choice("kurulus.balkonTadilat", "kendin", .bold,
                    tr: "Kendin yap (video eğitimli)",
                    outcomes: [
                        outcome("kurulus.balkonTadilat", "kendin", 1,
                            tr: "Bitti ve güzel oldu! O balkonda içilen ilk çay, gurur demlemesiydi.",
                            fx: [tl(-8_000), hp(5)]),
                        outcome("kurulus.balkonTadilat", "kendin", 2,
                            tr: "Yarım kaldı; çağırdığın usta 'kim yaptı bunu' diye sordu, sustun.",
                            fx: [tl(-20_000), hp(-2)]),
                    ]),
            ]
        ),

        news(
            "kurulus.dogumGunuSurprizi", seasons: [.kurulus], w: 10, cd: .years(4),
            tr: "Sana sürpriz doğum günü yapıldı; 'hiç şüphelenmedim' repliğin yılın oyunculuk performansıydı.",
            fx: [hp(4)]
        ),

        // Zincire bağlı: çocuk doğduktan 6 yıl sonra gelir. Havuzdan çekilseydi
        // bebek doğduğu yıl okula başlayabilirdi (docs/03 Faz 3 his turu).
        chained(
            "kurulus.cocukIlkGun",
            cond: [.hasFlag(.cocukVar)],
            tr: "Çocuğun okula başladı. Kapıda sen ağladın, o el sallayıp sınıfa koştu.",
            fx: [hp(3)]
        ),

        news(
            "kurulus.mangalZirvesi", seasons: [.kurulus], w: 10, cd: .years(3),
            tr: "Mangal başında 'köz oldu, olmadı' zirvesi toplandı; sen arabuluculuk yaptın, kupa sende.",
            fx: [so(2)]
        ),

        news(
            "kurulus.ilkEvEsyasi", seasons: [.kurulus], w: 8, cd: .years(5),
            tr: "İlk 'kendi paranla' koltuk takımı eve girdi; koruma naylonları bir ay çıkarılmadı.",
            fx: [hp(2)]
        ),
    ]
}
