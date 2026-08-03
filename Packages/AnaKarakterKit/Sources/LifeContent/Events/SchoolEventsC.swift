import LifeDomain

/// Okul (6–17) — Faz 4 içerik genişlemesi.
/// Sezon 12 yıl sürdüğü için neredeyse her olay yaş bandı beyan eder:
/// ilkokul, ortaokul ve lise aynı havuzdan çekilmemeli.
enum SchoolEventsC {
    static let all: [LifeEvent] = [

        // --- İlkokul (6–9) ---

        news(
            "okul.ilkCanta", seasons: [.okul], from: 6, to: 7, w: 12,
            tr: "Yeni çanta sırtta, defterler kokuyor, kalemler sırayla dizildi. Her şey yerli yerinde.",
            fx: [hp(3), iq(1)]
        ),

        decision(
            "okul.siraArkadasi", seasons: [.okul], from: 6, to: 9, w: 12,
            tr: "Öğretmen yer değişikliği yaptı. Yeni sıra arkadaşın hiç konuşmuyor.",
            choices: [
                choice("okul.siraArkadasi", "bekle", .safe,
                    tr: "Kendi hâline bırak",
                    outcomes: [
                        outcome("okul.siraArkadasi", "bekle", 1,
                            tr: "İki hafta sonra kendi konuştu; ilk cümlesi bir şaka oldu.",
                            fx: [so(2)]),
                    ]),
                choice("okul.siraArkadasi", "sohbet", .bold,
                    tr: "Silgini uzat, sohbeti başlat",
                    outcomes: [
                        outcome("okul.siraArkadasi", "sohbet", 1, w: 2,
                            tr: "Meğer aynı çizgi romanı okuyormuşsunuz. Sıra artık bir karargâh.",
                            fx: [so(7), flag(.kanka)]),
                        outcome("okul.siraArkadasi", "sohbet", 2,
                            tr: "Kısa bir 'hı hı' aldın. Olsun; herkesin ısınma süresi farklı.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "okul.bayrakToreni", seasons: [.okul], from: 6, to: 12, w: 10, cd: .years(3),
            tr: "Sabah töreninde en arka sıradasın; marş bitince sınıfa koşma yarışı başlıyor.",
            fx: [so(2)]
        ),

        decision(
            "okul.beslenmeCantasi", seasons: [.okul], from: 6, to: 10, w: 10,
            tr: "Beslenme saatinde çantandan annenin hazırladığı devasa sandviç çıktı.",
            choices: [
                choice("okul.beslenmeCantasi", "kendinYe", .safe,
                    tr: "Sessizce ye",
                    outcomes: [
                        outcome("okul.beslenmeCantasi", "kendinYe", 1,
                            tr: "Karnın doydu, teneffüs uzun geldi. Fena bir gün değildi.",
                            fx: [hl(2)]),
                    ]),
                choice("okul.beslenmeCantasi", "paylas", .bold,
                    tr: "Sınıfa böl",
                    outcomes: [
                        outcome("okul.beslenmeCantasi", "paylas", 1, w: 2,
                            tr: "Sandviç efsane oldu; ertesi gün üç kişi 'annen ne koydu?' diye sordu.",
                            fx: [so(7)]),
                        outcome("okul.beslenmeCantasi", "paylas", 2,
                            tr: "Sana bir lokma kaldı; öğleden sonra ders uzun sürdü.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "okul.resimDersi", seasons: [.okul], from: 6, to: 11, w: 10, cd: .years(4),
            tr: "Resim dersinde çizdiğin ev panoya asıldı. Bacadan çıkan duman biraz iddialıydı.",
            fx: [hp(2), iq(1)]
        ),

        news(
            "okul.okulKantini", seasons: [.okul], from: 7, w: 10, cd: .years(3),
            tr: "Kantinde poğaça kuyruğu uzun; zil çalmadan yetişmek bir sanat.",
            fx: [hp(1), so(1)]
        ),

        decision(
            "okul.ilkOdev", seasons: [.okul], from: 7, to: 11, w: 10,
            tr: "Hafta sonu için proje ödevi verildi: 'Ailemin mesleği'. Pazar akşamı yaklaşıyor.",
            choices: [
                choice("okul.ilkOdev", "erken", .safe,
                    tr: "Cumartesi bitir",
                    outcomes: [
                        outcome("okul.ilkOdev", "erken", 1,
                            tr: "Pazar boş kaldı; hem ödev bitti hem sokak seni bekledi.",
                            fx: [iq(2)]),
                    ]),
                choice("okul.ilkOdev", "sonAksam", .bold,
                    tr: "Pazar gecesi tek seferde",
                    outcomes: [
                        outcome("okul.ilkOdev", "sonAksam", 1, w: 2,
                            tr: "Gece yarısı biten proje sınıfın en iyisi çıktı. Baskı altında parlıyorsun.",
                            fx: [iq(6)]),
                        outcome("okul.ilkOdev", "sonAksam", 2,
                            tr: "Yarım kaldı; öğretmen 'yeteneğin var ama' cümlesini kurdu.",
                            fx: [iq(-6)]),
                    ]),
            ]
        ),

        news(
            "okul.kutuphaneKarti", seasons: [.okul], from: 8, w: 8, cd: .years(4),
            tr: "Okul kütüphanesinden ilk kartın çıktı. İlk kitabı üç günde bitirdin.",
            fx: [iq(3), flag(.kitapKurdu)]
        ),

        // --- Ortaokul (10–13) ---

        decision(
            "okul.grupCalismasi", seasons: [.okul], from: 10, to: 14, w: 10,
            tr: "Grup ödevinde herkes 'sonra yaparım' diyor. Teslim üç gün sonra.",
            choices: [
                choice("okul.grupCalismasi", "kendinYap", .safe,
                    tr: "Hepsini kendin topla",
                    outcomes: [
                        outcome("okul.grupCalismasi", "kendinYap", 1,
                            tr: "Ödev teslim edildi; teşekkürler biraz geç geldi ama geldi.",
                            fx: [iq(2)]),
                    ]),
                choice("okul.grupCalismasi", "gorevDagit", .bold,
                    tr: "Görev dağıt, takibi üstlen",
                    outcomes: [
                        outcome("okul.grupCalismasi", "gorevDagit", 1, w: 2,
                            tr: "Herkes payını getirdi; grup seni bir daha sözcü seçti.",
                            fx: [so(7), flag(.lider)]),
                        outcome("okul.grupCalismasi", "gorevDagit", 2,
                            tr: "İki kişi gelmedi, sunum aksadı; liderlik bazen yalnız bırakır.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "okul.mudurOdasi", seasons: [.okul], from: 10, to: 15, w: 8, cd: .years(4),
            tr: "Koridorda koşarken müdür yardımcısına yakalandın. Ceza: iki tur nasihat.",
            fx: [hp(-2), so(1)]
        ),

        decision(
            "okul.ilkKrediliHarclik", seasons: [.okul], from: 11, w: 10, cd: .years(4),
            tr: "Harçlık haftalık verilmeye başlandı. Cuma günü cüzdan bakıyor sana.",
            choices: [
                choice("okul.ilkKrediliHarclik", "biriktir", .safe,
                    tr: "Bir kısmını biriktir",
                    outcomes: [
                        outcome("okul.ilkKrediliHarclik", "biriktir", 1,
                            tr: "Kumbara ağırlaştı; ay sonunda kendine küçük bir hediye aldın.",
                            fx: [tl(20_000)]),
                    ]),
                choice("okul.ilkKrediliHarclik", "hepsiniHarca", .bold,
                    tr: "Hepsini ilk gün harca",
                    outcomes: [
                        outcome("okul.ilkKrediliHarclik", "hepsiniHarca", 1, w: 2,
                            tr: "Efsane bir gün geçirdin; anlatılan hikâye harcanan paradan değerliydi.",
                            fx: [tl(60_000), hp(2)]),
                        outcome("okul.ilkKrediliHarclik", "hepsiniHarca", 2,
                            tr: "Salı günü cüzdan boştu. Haftanın kalanı uzun sürdü.",
                            fx: [tl(-60_000), hp(-2)]),
                    ]),
            ]
        ),

        news(
            "okul.dersDisiKulup", seasons: [.okul], from: 10, w: 10, cd: .years(4),
            tr: "Kulüp seçim panosu asıldı: münazara, fotoğraf, tiyatro, satranç. Karar zor.",
            fx: [iq(2), so(1)]
        ),

        decision(
            "okul.ilkKavga", seasons: [.okul], from: 10, to: 15, w: 8,
            tr: "Bahçede bir tartışma büyüdü; çevrende halka oluştu.",
            choices: [
                choice("okul.ilkKavga", "araBul", .safe,
                    tr: "Araya gir, konuşturt",
                    outcomes: [
                        outcome("okul.ilkKavga", "araBul", 1,
                            tr: "İkisi de sakinleşti; öğretmen gelmeden dağıldı. Sen kazandın.",
                            fx: [so(3), hp(1)]),
                    ]),
                choice("okul.ilkKavga", "cekil", .neutral,
                    tr: "Uzaklaş, karışma",
                    outcomes: [
                        outcome("okul.ilkKavga", "cekil", 1,
                            tr: "Kendini korudun. Bazı kavgalar senin kavgan değildir.",
                            fx: [hl(1)]),
                    ]),
            ]
        ),

        news(
            "okul.sinifPanosu", seasons: [.okul], from: 9, to: 14, w: 8, cd: .years(4),
            tr: "Sınıf panosunu hazırlama görevi sana verildi. Renkli kartonlar tükendi, fikirler tükenmedi.",
            fx: [iq(2), so(2)]
        ),

        decision(
            "okul.spordaSecme", seasons: [.okul], from: 11, to: 16, w: 10,
            tr: "Okul takımı seçmeleri var. Antrenör listeye bakıyor, sen sıradasın.",
            choices: [
                choice("okul.spordaSecme", "yedek", .safe,
                    tr: "Yedek kulübesine razı ol",
                    outcomes: [
                        outcome("okul.spordaSecme", "yedek", 1,
                            tr: "Her antrenmana geldin; sezon sonunda 'en çalışkan' sensin.",
                            fx: [hl(2)]),
                    ]),
                choice("okul.spordaSecme", "kaptanlik", .bold,
                    tr: "Kaptanlık için çık",
                    outcomes: [
                        outcome("okul.spordaSecme", "kaptanlik", 1, w: 2,
                            tr: "Pazıbandı senin oldu; takım arkasında, tribün önünde.",
                            fx: [hl(6), flag(.sporcuRuh)]),
                        outcome("okul.spordaSecme", "kaptanlik", 2,
                            tr: "Seçmelerde sakatlandın; iki ay saha kenarında izledin.",
                            fx: [hl(-6)]),
                    ]),
            ]
        ),

        news(
            "okul.ilkKonser", seasons: [.okul], from: 12, w: 8, cd: .years(5),
            tr: "Okul bahçesinde grup kurulmuş; amfi bozuk, davul gecikmiş, coşku tam.",
            fx: [so(3), hp(2)]
        ),

        // --- Lise (14–17) ---

        decision(
            "okul.liseIlkGun", seasons: [.okul], from: 14, to: 15, w: 12,
            tr: "Lisenin ilk günü: koridorlar daha uzun, herkes daha uzun, sen aynısın.",
            choices: [
                choice("okul.liseIlkGun", "gozlemle", .safe,
                    tr: "Önce gözlemle",
                    outcomes: [
                        outcome("okul.liseIlkGun", "gozlemle", 1,
                            tr: "Bir hafta izledin, sonra doğru masaya oturdun. Sabır işe yaradı.",
                            fx: [so(2)]),
                    ]),
                choice("okul.liseIlkGun", "tanit", .bold,
                    tr: "Kendini ilk gün tanıt",
                    outcomes: [
                        outcome("okul.liseIlkGun", "tanit", 1, w: 2,
                            tr: "Adını herkes öğrendi; ikinci hafta sınıf temsilcisi adayısın.",
                            fx: [so(7)]),
                        outcome("okul.liseIlkGun", "tanit", 2,
                            tr: "Biraz fazla hevesli göründün; birkaç gün utandın, sonra unutuldu.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "okul.dershaneKursu", seasons: [.okul], from: 15, w: 10, cd: .years(3),
            tr: "Hafta sonu kursu başladı. Uyku azaldı, deneme sınavı sayısı arttı.",
            fx: [iq(3), hl(-1)]
        ),

        decision(
            "okul.ilkParaKazanma", seasons: [.okul], from: 15, w: 10,
            tr: "Yaz için bir iş çıktı: dükkânda hafta sonu yardım. Ücret mütevazı.",
            choices: [
                choice("okul.ilkParaKazanma", "calis", .safe,
                    tr: "Kabul et, düzenli çalış",
                    outcomes: [
                        outcome("okul.ilkParaKazanma", "calis", 1,
                            tr: "İlk maaşını aldın; ilk harcaman anneye hediye oldu.",
                            fx: [tl(20_000), so(1)]),
                    ]),
                choice("okul.ilkParaKazanma", "kendiIsi", .bold,
                    tr: "Kendi işini kur: mahalleye servis",
                    outcomes: [
                        outcome("okul.ilkParaKazanma", "kendiIsi", 1, w: 2,
                            tr: "Sipariş defterin doldu; mahalle 'bizim çocuk' diye anlatıyor.",
                            fx: [tl(60_000), flag(.girisimciRuh)]),
                        outcome("okul.ilkParaKazanma", "kendiIsi", 2,
                            tr: "Malzeme masrafı geliri yedi. Ders pahalı ama kalıcı oldu.",
                            fx: [tl(-60_000)]),
                    ]),
            ]
        ),

        news(
            "okul.mezuniyetProvasi", seasons: [.okul], from: 16, to: 17, w: 10,
            tr: "Mezuniyet provası: cübbeler büyük, şapkalar eğri, fotoğraflar bol.",
            fx: [hp(3), so(2)]
        ),

        decision(
            "okul.ilkHeyecan", seasons: [.okul], from: 15, to: 17, w: 10,
            tr: "Koridorda biriyle göz göze geldiniz. Kalp ritmi ders programını bozdu.",
            choices: [
                choice("okul.ilkHeyecan", "sakla", .safe,
                    tr: "Kendine sakla",
                    outcomes: [
                        outcome("okul.ilkHeyecan", "sakla", 1,
                            tr: "Defterin köşesinde kalan bir isim; yıllar sonra gülümseterek hatırlanacak.",
                            fx: [hp(2)]),
                    ]),
                choice("okul.ilkHeyecan", "soyle", .bold,
                    tr: "Söyle gitsin",
                    outcomes: [
                        outcome("okul.ilkHeyecan", "soyle", 1, w: 2,
                            tr: "Karşılık buldu! Okul çıkışları bir anda daha uzun sürmeye başladı.",
                            fx: [hp(6)]),
                        outcome("okul.ilkHeyecan", "soyle", 2,
                            tr: "Nazik bir 'arkadaş kalalım' geldi. Cesaret hanesine yazıldı.",
                            fx: [hp(-6)]),
                    ]),
            ]
        ),

        news(
            "okul.ilkSinavStresi", seasons: [.okul], from: 16, to: 17, w: 12, cd: .years(2),
            tr: "Deneme sonuçları asıldı. Herkes kendi sırasını arıyor, kimse yüksek sesle konuşmuyor.",
            fx: [iq(2), hp(-2)]
        ),

        decision(
            "okul.gelecekPlani", seasons: [.okul], from: 16, to: 17, w: 10,
            tr: "Rehber öğretmen sordu: 'Ne olmak istiyorsun?' Cevap hazır değil.",
            choices: [
                choice("okul.gelecekPlani", "guvenli", .safe,
                    tr: "Ailenin önerdiği yolu söyle",
                    outcomes: [
                        outcome("okul.gelecekPlani", "guvenli", 1,
                            tr: "Herkes rahatladı; sen de bir süre rahatladın.",
                            fx: [iq(2)]),
                    ]),
                choice("okul.gelecekPlani", "kendiYol", .bold,
                    tr: "İçinden geleni söyle",
                    outcomes: [
                        outcome("okul.gelecekPlani", "kendiYol", 1, w: 2,
                            tr: "Öğretmen not aldı: 'Bu çocuk biliyor.' O gün bir şey oturdu.",
                            fx: [iq(6)]),
                        outcome("okul.gelecekPlani", "kendiYol", 2,
                            tr: "'Gerçekçi ol' cevabını aldın. Not defterine yine de yazdın.",
                            fx: [iq(-6)]),
                    ]),
            ]
        ),

        news(
            "okul.sonZil", seasons: [.okul], from: 17, to: 17, w: 12,
            tr: "Son zil çaldı. Defterler havaya atıldı, kimse eve gitmek istemedi.",
            fx: [hp(4), so(3)]
        ),

        news(
            "okul.okulServisi", seasons: [.okul], from: 6, to: 13, w: 8, cd: .years(4),
            tr: "Serviste pencere kenarı kapıldı; cam buğusuna isim yazma geleneği sürüyor.",
            fx: [hp(2)]
        ),

        news(
            "okul.kitapFuari", seasons: [.okul], from: 12, w: 8, cd: .years(5),
            tr: "Okul kitap fuarında bütçe yetmedi; iki kitap alındı, beşi not edildi.",
            fx: [iq(3)]
        ),

        decision(
            "okul.dijitalOyun", seasons: [.okul], from: 12, to: 17, w: 10, cd: .years(4),
            tr: "Arkadaş grubu akşam turnuvası kuruyor; yarın ilk ders sınav.",
            choices: [
                choice("okul.dijitalOyun", "erkenYat", .safe,
                    tr: "Erken yat",
                    outcomes: [
                        outcome("okul.dijitalOyun", "erkenYat", 1,
                            tr: "Dinlenmiş uyandın; sınav beklediğinden kolay geldi.",
                            fx: [iq(2)]),
                    ]),
                choice("okul.dijitalOyun", "turnuva", .bold,
                    tr: "Turnuvaya kal",
                    outcomes: [
                        outcome("okul.dijitalOyun", "turnuva", 1, w: 2,
                            tr: "Şampiyon oldunuz; sınavı da bir şekilde çıkardın. İki cephede zafer.",
                            fx: [so(7)]),
                        outcome("okul.dijitalOyun", "turnuva", 2,
                            tr: "Sabaha karşı yatıldı; sınavda ilk soruya uzun uzun bakıldı.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "okul.ogretmenMektubu", seasons: [.okul], from: 14, w: 8, cd: .years(5),
            tr: "Bir öğretmen defterinin arkasına not yazmış: 'Sen anlatmayı biliyorsun.' Cümle kaldı.",
            fx: [iq(2), hp(2)]
        ),
    ]
}
