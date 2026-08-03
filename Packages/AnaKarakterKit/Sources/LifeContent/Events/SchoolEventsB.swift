import LifeDomain

/// Okul (6–17) — Faz 2 genişletmesi.
enum SchoolEventsB {
    static let all: [LifeEvent] = [

        news(
            "okul.yeniOgretmen", seasons: [.okul], w: 10, cd: .years(4),
            tr: "Yeni öğretmen geldi ve ilk günden bütün isimleri ezberledi. Sınıf hâlâ şokta.",
            fx: [iq(1)]
        ),

        decision(
            "okul.satrancKulubu", seasons: [.okul], from: 8, w: 10,
            tr: "Okulda satranç kulübü açıldı; panoda turnuva ilanı asılı.",
            choices: [
                choice("okul.satrancKulubu", "izleyici", .safe,
                    tr: "Maçları izleyerek öğren",
                    outcomes: [
                        outcome("okul.satrancKulubu", "izleyici", 1,
                            tr: "Kenardan taktik topladın; at hâlâ L çiziyor, sen artık biliyorsun.",
                            fx: [iq(1)]),
                    ]),
                choice("okul.satrancKulubu", "turnuva", .bold,
                    tr: "Turnuvaya yazıl",
                    outcomes: [
                        outcome("okul.satrancKulubu", "turnuva", 1,
                            tr: "İlk turda sürpriz galibiyet! Rakibin şaşkınlığı panoya asılacak kadar netti.",
                            fx: [iq(5)]),
                        outcome("okul.satrancKulubu", "turnuva", 2,
                            tr: "İlk turda veda; ama açılışları öğrendin, seneye görüşürüz.",
                            fx: [hp(-3)]),
                    ]),
            ]
        ),

        decision(
            "okul.okulGezisi", seasons: [.okul], w: 10,
            tr: "Okul gezisi günü: sabah müze, öğleden sonra serbest saat.",
            choices: [
                choice("okul.okulGezisi", "grup", .safe,
                    tr: "Gruptan ayrılma",
                    outcomes: [
                        outcome("okul.okulGezisi", "grup", 1,
                            tr: "Rehberi can kulağıyla dinledin; dönüş yoklamasında ilk 'burada' sendin.",
                            fx: [iq(2)]),
                    ]),
                choice("okul.okulGezisi", "kesif", .bold,
                    tr: "Serbest saatte kafadan planla şehri keşfe çık",
                    outcomes: [
                        outcome("okul.okulGezisi", "kesif", 1,
                            tr: "Efsane sokaklar, efsane fotoğraflar — ve dakikası dakikasına dönüş.",
                            fx: [hp(5)]),
                        outcome("okul.okulGezisi", "kesif", 2,
                            tr: "Otobüs seni on dakika bekledi. Öğretmenin bakışı ömürlük hatıra.",
                            fx: [so(-4)]),
                    ]),
            ]
        ),

        decision(
            "okul.kermes", seasons: [.okul], from: 8, w: 10,
            tr: "Okul kermesi yaklaşıyor; sınıfın standı sana emanet edildi.",
            choices: [
                choice("okul.kermes", "limonata", .neutral,
                    tr: "Limonata standı — klasik ve garanti",
                    outcomes: [
                        outcome("okul.kermes", "limonata", 1,
                            tr: "Sıcak gün, soğuk limonata: kuyruk hiç bitmedi.",
                            fx: [so(2), tl(1_000)]),
                    ]),
                choice("okul.kermes", "tost", .bold,
                    tr: "Kendi icadın: karışık tost menüsü",
                    outcomes: [
                        outcome("okul.kermes", "tost", 1, w: 2,
                            tr: "Stant rekor kırdı; 'şefin spesiyali' kermes tarihine geçti.",
                            fx: [so(4), tl(2_000)]),
                        outcome("okul.kermes", "tost", 2,
                            tr: "Tostlar yandı. İtfaiye gelmedi ama koku üç sınıfı gezdi.",
                            fx: [so(-3), tl(-500)]),
                    ]),
            ]
        ),

        news(
            "okul.yazTatiliKoy", seasons: [.okul], w: 10, cd: .years(3),
            tr: "Yaz tatili memlekette: traktör römorku, dut ağacı, dizlerde yara — kalpte bayram.",
            fx: [hp(3), hl(1)]
        ),

        decision(
            "okul.matematikSinavi", seasons: [.okul], from: 8, w: 10, cd: .years(3),
            tr: "Matematik yazılısı kapıda. Konu: problemler. Hayat: aynen öyle.",
            choices: [
                choice("okul.matematikSinavi", "planli", .safe,
                    tr: "Planlı tekrarla çalış",
                    outcomes: [
                        outcome("okul.matematikSinavi", "planli", 1,
                            tr: "Konular oturdu; sınavda kalem hiç durmadı.",
                            fx: [iq(3)]),
                    ]),
                choice("okul.matematikSinavi", "sonDakika", .bold,
                    tr: "Gece 'son dakika efsanesi' taktiği",
                    outcomes: [
                        outcome("okul.matematikSinavi", "sonDakika", 1,
                            tr: "Tuttu! Çalıştığın üç soru tipi de çıktı; efsane doğrulandı.",
                            fx: [iq(5), hp(1)]),
                        outcome("okul.matematikSinavi", "sonDakika", 2,
                            tr: "Ders kitabının üstünde uyuyakaldın; formüller rüyada kaldı.",
                            fx: [iq(-4)]),
                    ]),
            ]
        ),

        decision(
            "okul.okulKorosu", seasons: [.okul], from: 8, w: 10,
            tr: "Okul korosu üye arıyor; müzik öğretmeni gözüne kestirdiklerini tek tek çağırıyor.",
            choices: [
                choice("okul.okulKorosu", "katil", .neutral,
                    tr: "Koroya katıl",
                    outcomes: [
                        outcome("okul.okulKorosu", "katil", 1,
                            tr: "23 Nisan sahnesinde ikinci sıradasın; ailen seni hemen buldu.",
                            fx: [so(3)]),
                    ]),
                choice("okul.okulKorosu", "dinlen", .neutral,
                    tr: "Ses telleri dinlensin",
                    outcomes: [
                        outcome("okul.okulKorosu", "dinlen", 1,
                            tr: "Sen dinleyici tarafını seçtin; alkışın da bir görev olduğunu kanıtladın.",
                            fx: [hp(1)]),
                    ]),
            ]
        ),

        decision(
            "okul.vitrindekiSey", seasons: [.okul], from: 8, w: 10, cd: .years(3),
            tr: "Vitrindeki o şey sana bakıyor. Harçlık hesabı yapıldı: üç hafta, belki dört.",
            choices: [
                choice("okul.vitrindekiSey", "biriktir", .safe,
                    tr: "Biriktir, planla, öyle al",
                    outcomes: [
                        outcome("okul.vitrindekiSey", "biriktir", 1,
                            tr: "Üç haftalık sabır meyvesini verdi; alırken elin titredi, değdi.",
                            fx: [hp(3), tl(-1_500)]),
                    ]),
                choice("okul.vitrindekiSey", "hemen", .bold,
                    tr: "Harçlık + kumbara: hemen al",
                    outcomes: [
                        outcome("okul.vitrindekiSey", "hemen", 1,
                            tr: "İlk gün, ilk sahibi sensin. Okulda herkes bakmaya geldi.",
                            fx: [hp(5), tl(-2_000)]),
                        outcome("okul.vitrindekiSey", "hemen", 2,
                            tr: "Bir hafta sonra indirime girdi. Bu acı unutulmaz ama anlatılır.",
                            fx: [hp(-2), tl(-2_000)]),
                    ]),
            ]
        ),

        news(
            "okul.sinifPiknigi", seasons: [.okul], w: 10, cd: .years(3),
            tr: "Sınıf pikniği: top oynandı, sandviçler paylaşıldı, bir termos kayboldu, yüz fotoğraf çekildi.",
            fx: [so(2)]
        ),

        decision(
            "okul.bilgisayarKursu", seasons: [.okul], from: 10, w: 10,
            tr: "Bilgisayar dersinde bir şey dikkatini çekti: bu kutu, söyleneni yapıyor.",
            choices: [
                choice("okul.bilgisayarKursu", "okulKursu", .safe,
                    tr: "Okulun kursuna yazıl",
                    outcomes: [
                        outcome("okul.bilgisayarKursu", "okulKursu", 1,
                            tr: "Adım adım öğrendin; klavye artık yabancı değil.",
                            fx: [iq(2)]),
                    ]),
                choice("okul.bilgisayarKursu", "kendiBasina", .bold,
                    tr: "Kendi başına kurcala (internet hocan olsun)",
                    outcomes: [
                        outcome("okul.bilgisayarKursu", "kendiBasina", 1, w: 2,
                            tr: "İlk küçük programın çalıştı! Ekrandaki 'Merhaba' sana dünyanın en güzel kelimesi.",
                            fx: [iq(5), flag(.teknoMeraki)]),
                        outcome("okul.bilgisayarKursu", "kendiBasina", 2,
                            tr: "Ekran başında saatler eridi; göz kararması bedava.",
                            fx: [hl(-2)]),
                    ]),
            ]
        ),

        decision(
            "okul.ilkTelefon", seasons: [.okul], from: 11, w: 10,
            tr: "İlk telefon meselesi evde gündemin bir numarası.",
            choices: [
                choice("okul.ilkTelefon", "ailePlani", .neutral,
                    tr: "Ailenin planına uy",
                    outcomes: [
                        outcome("okul.ilkTelefon", "ailePlani", 1,
                            tr: "'Sınıfı geçince' anlaşması imzalandı; motivasyon tavan.",
                            fx: [hp(1)]),
                    ]),
                choice("okul.ilkTelefon", "ikinciEl", .neutral,
                    tr: "Kendi biriktirdiğinle ekranı çatlak bir ikinci el al",
                    outcomes: [
                        outcome("okul.ilkTelefon", "ikinciEl", 1,
                            tr: "Çatlak ekran, tam bağımsızlık. Mesajlaşma çağına giriş yapıldı.",
                            fx: [so(2), tl(-1_000)]),
                    ]),
            ]
        ),

        decision(
            "okul.alanSecimi", seasons: [.okul], from: 14, to: 15, w: 10,
            tr: "Lisede alan seçimi haftası: sayısal mı, sözel mi, eşit ağırlık mı? Herkesin bir fikri var.",
            choices: [
                choice("okul.alanSecimi", "sayisal", .neutral,
                    tr: "Sayısal",
                    outcomes: [
                        outcome("okul.alanSecimi", "sayisal", 1,
                            tr: "Formüller ve deneyler dünyasına giriş yapıldı.",
                            fx: [iq(3)]),
                    ]),
                choice("okul.alanSecimi", "sozel", .neutral,
                    tr: "Sözel",
                    outcomes: [
                        outcome("okul.alanSecimi", "sozel", 1,
                            tr: "Tarihler, metinler, haritalar — hikâyelerin tarafını seçtin.",
                            fx: [so(3)]),
                    ]),
                choice("okul.alanSecimi", "esitAgirlik", .neutral,
                    tr: "Eşit ağırlık",
                    outcomes: [
                        outcome("okul.alanSecimi", "esitAgirlik", 1,
                            tr: "İki dünyanın da kapısı açık kaldı; kararsızlığın stratejik hâli.",
                            fx: [iq(2), so(1)]),
                    ]),
            ]
        ),

        news(
            "okul.kutuphaneKesfi", seasons: [.okul], from: 9, w: 8,
            cond: [.hasFlag(.kitapKurdu)],
            tr: "Şehir kütüphanesinde kendi köşeni buldun; görevli artık seni ismiyle karşılıyor.",
            fx: [iq(3)]
        ),
    ]
}
