import LifeDomain

/// Hayatın arka planı — sezonlara yayılmış küçük anlar.
///
/// Bu dosyadaki olayların çoğu birden fazla sezonda geçerlidir: bir çay
/// molası da, bir kesinti de her yaşta olur. Amaç, omurga olayların arasını
/// dolduran "hayat dokusu"nu vermek (docs/03: çeşitlilik metriği).
enum SliceOfLifeEvents {
    static let all: [LifeEvent] = [

        news(
            "hayat.elektrikKesintisi", seasons: [.okul, .yolAyrimi, .kurulus, .ortaSahne], w: 8, cd: .years(5),
            tr: "Elektrikler kesildi. Mumlar çıktı, telefonlar sustu, sohbet uzadı.",
            fx: [so(2), hp(2)]
        ),

        news(
            "hayat.ilkYagmur", seasons: [.cocukluk, .okul, .yolAyrimi], from: 5, w: 8, cd: .years(4),
            tr: "Yazın ilk yağmuru: asfalt kokusu, açık pencere, kimse içeri girmek istemedi.",
            fx: [hp(3)]
        ),

        news(
            "hayat.komsununRadyosu", seasons: [.kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(5),
            tr: "Komşunun radyosu yine açık. Şarkıyı sen de mırıldandın, kimseye söylemedin.",
            fx: [hp(2)]
        ),

        decision(
            "hayat.kayipEsya", seasons: [.okul, .yolAyrimi, .kurulus], from: 10, w: 8, cd: .years(5),
            tr: "Otobüste bir cüzdan buldun. İçinde kimlik ve az bir para var.",
            choices: [
                choice("hayat.kayipEsya", "sofore", .safe,
                    tr: "Şoföre teslim et",
                    outcomes: [
                        outcome("hayat.kayipEsya", "sofore", 1,
                            tr: "Doğru şey yapıldı; iyi bir gün olarak hatırlandı.",
                            fx: [hp(2)]),
                    ]),
                choice("hayat.kayipEsya", "sahibineUlas", .bold,
                    tr: "Kimlikten sahibini bul, kendin ulaştır",
                    outcomes: [
                        outcome("hayat.kayipEsya", "sahibineUlas", 1, w: 2,
                            tr: "Kapıda uzun uzun teşekkür edildi; yıllar sonra hâlâ selamlaşıyorsunuz.",
                            fx: [so(7)]),
                        outcome("hayat.kayipEsya", "sahibineUlas", 2,
                            tr: "Adres yanlış çıktı, yarım gün gitti. Niyet yerindeydi.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "hayat.mahalleKedisi", seasons: [.okul, .yolAyrimi, .kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(4),
            tr: "Sokak kedisi kapının önünde bekliyor. Mama kabı sessizce dolduruldu.",
            fx: [hp(2)]
        ),

        decision(
            "hayat.kuyrukAdabi", seasons: [.yolAyrimi, .kurulus, .ortaSahne], w: 8, cd: .years(5),
            tr: "Kuyrukta biri öne geçti. Arkadan homurdanma sesleri yükseliyor.",
            choices: [
                choice("hayat.kuyrukAdabi", "gormezden", .safe,
                    tr: "Görmezden gel",
                    outcomes: [
                        outcome("hayat.kuyrukAdabi", "gormezden", 1,
                            tr: "İki dakika sonra unutuldu. Bazı şeyler büyütülmemeli.",
                            fx: [hp(2)]),
                    ]),
                choice("hayat.kuyrukAdabi", "uyar", .bold,
                    tr: "Kibarca uyar",
                    outcomes: [
                        outcome("hayat.kuyrukAdabi", "uyar", 1, w: 2,
                            tr: "Özür diledi, arkaya geçti; kuyruk sana teşekkür etti.",
                            fx: [so(7)]),
                        outcome("hayat.kuyrukAdabi", "uyar", 2,
                            tr: "Ters cevap geldi; gün boyu ağzının tadı kaçtı.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "hayat.gecikenOtobus", seasons: [.okul, .yolAyrimi, .kurulus], from: 12, w: 8, cd: .years(4),
            tr: "Otobüs yirmi dakika gecikti. Durakta tanımadığın biriyle güzel bir sohbet çıktı.",
            fx: [so(2)]
        ),

        news(
            "hayat.baharTemizligi", seasons: [.kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(3),
            tr: "Bahar temizliği: perdeler indi, camlar açıldı, ev bambaşka koktu.",
            fx: [hp(2), hl(1)]
        ),

        decision(
            "hayat.yardimEli", seasons: [.yolAyrimi, .kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(5),
            tr: "Sokakta yaşlı bir kadın ağır poşetlerle merdivene bakıyor.",
            choices: [
                choice("hayat.yardimEli", "sor", .safe,
                    tr: "Yardım gerekiyor mu diye sor",
                    outcomes: [
                        outcome("hayat.yardimEli", "sor", 1,
                            tr: "'Sağ ol evladım' dedi ve kendi çıktı. Sorman yetmişti.",
                            fx: [so(2)]),
                    ]),
                choice("hayat.yardimEli", "tasi", .bold,
                    tr: "Poşetleri al, kata çıkar",
                    outcomes: [
                        outcome("hayat.yardimEli", "tasi", 1, w: 2,
                            tr: "Kapıda çay ikram edildi; yarım saat sonra iki tarihi dinlemiş oldun.",
                            fx: [so(7)]),
                        outcome("hayat.yardimEli", "tasi", 2,
                            tr: "Poşet yırtıldı, portakallar merdivenden aşağı gitti. Gülüştünüz.",
                            fx: [so(-8)]),
                    ]),
            ]
        ),

        news(
            "hayat.evTamiri", seasons: [.kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(4),
            tr: "Musluk damlıyordu; alet çantası çıkarıldı ve iş bir saatte halledildi.",
            fx: [iq(2), hp(2)]
        ),

        news(
            "hayat.tanidikKoku", seasons: [.okul, .yolAyrimi, .kurulus, .ortaSahne, .finalSezonu], from: 10, w: 8, cd: .years(5),
            tr: "Sokakta tanıdık bir yemek kokusu geçti; bir anda çocukluğunun mutfağındaydın.",
            fx: [hp(3)]
        ),

        decision(
            "hayat.telefonSatici", seasons: [.yolAyrimi, .kurulus, .ortaSahne], w: 8, cd: .years(5),
            tr: "Telefonda ısrarcı bir kampanya teklifi. Karşı taraf kapatmaya niyetli değil.",
            choices: [
                choice("hayat.telefonSatici", "kapat", .safe,
                    tr: "Nazikçe kapat",
                    outcomes: [
                        outcome("hayat.telefonSatici", "kapat", 1,
                            tr: "İki dakika kaybedildi, para kaybedilmedi.",
                            fx: [hp(2)]),
                    ]),
                choice("hayat.telefonSatici", "dinle", .neutral,
                    tr: "Sonuna kadar dinle",
                    outcomes: [
                        outcome("hayat.telefonSatici", "dinle", 1,
                            tr: "İşe yarar bir bilgi çıktı; bir aboneliği ucuzlattın.",
                            fx: [tl(8_000)]),
                    ]),
            ]
        ),

        news(
            "hayat.kitapOnerisi", seasons: [.yolAyrimi, .kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(4),
            tr: "Biri sana bir kitap önerdi ve kendi nüshasını verdi. İçinde notları da varmış.",
            fx: [iq(3), so(1)]
        ),

        news(
            "hayat.balkonAksami", seasons: [.kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(3),
            tr: "Balkonda akşam çayı: sokak sesleri, uzaktan bir maç anonsu, serin bir rüzgâr.",
            fx: [hp(3)]
        ),

        decision(
            "hayat.eskiEsyalar", seasons: [.kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(6),
            tr: "Depo doldu. Yıllardır dokunulmayan kutular kararını bekliyor.",
            choices: [
                choice("hayat.eskiEsyalar", "sakla", .safe,
                    tr: "Dursun, yer var",
                    outcomes: [
                        outcome("hayat.eskiEsyalar", "sakla", 1,
                            tr: "Kutular yerinde kaldı; içindeki hatıralar da öyle.",
                            fx: [hp(2)]),
                    ]),
                choice("hayat.eskiEsyalar", "bagisla", .bold,
                    tr: "Ayıkla, ihtiyacı olana ver",
                    outcomes: [
                        outcome("hayat.eskiEsyalar", "bagisla", 1, w: 2,
                            tr: "Depo boşaldı, ev nefes aldı; birileri de sevindi.",
                            fx: [hp(6), so(2)]),
                        outcome("hayat.eskiEsyalar", "bagisla", 2,
                            tr: "Bir kutuyu yanlışlıkla verdin; içindeki fotoğraflar aklında kaldı.",
                            fx: [hp(-6)]),
                    ]),
            ]
        ),

        news(
            "hayat.komsuTamiri", seasons: [.kurulus, .ortaSahne], w: 8, cond: [.hasFlag(.iyiKomsu)], cd: .years(4),
            tr: "Üst kat 'bir bakar mısın' dedi; yarım saatte hallettin, karşılığında börek geldi.",
            fx: [so(3), hp(2)]
        ),

        news(
            "hayat.pazarGunu", seasons: [.kurulus, .ortaSahne, .finalSezonu], w: 10, cd: .years(3),
            tr: "Semt pazarı: pazarlık yapıldı, fazladan maydanoz alındı, poşetler ağırdı.",
            fx: [hp(2), tl(-3_000)]
        ),

        news(
            "hayat.uzunYolMuzigi", seasons: [.yolAyrimi, .kurulus, .ortaSahne], w: 8, cd: .years(4),
            tr: "Uzun yolda çalma listesi tam yerini buldu; kimse konuşmadı, herkes dinledi.",
            fx: [hp(3)]
        ),

        decision(
            "hayat.sabahAlarmi", seasons: [.yolAyrimi, .kurulus, .ortaSahne], w: 8, cd: .years(5),
            tr: "Alarm çaldı. Yatak sıcak, sabah soğuk, gün uzun.",
            choices: [
                choice("hayat.sabahAlarmi", "erteleme", .safe,
                    tr: "Hemen kalk",
                    outcomes: [
                        outcome("hayat.sabahAlarmi", "erteleme", 1,
                            tr: "Sakin bir sabah oldu; kahvaltı bile yapıldı.",
                            fx: [hl(2)]),
                    ]),
                choice("hayat.sabahAlarmi", "besDakika", .bold,
                    tr: "Beş dakika daha",
                    outcomes: [
                        outcome("hayat.sabahAlarmi", "besDakika", 1, w: 2,
                            tr: "O beş dakika efsaneydi; yine de her yere zamanında yetiştin.",
                            fx: [hl(6)]),
                        outcome("hayat.sabahAlarmi", "besDakika", 2,
                            tr: "Beş dakika kırk oldu. Gün koşarak başladı.",
                            fx: [hl(-6)]),
                    ]),
            ]
        ),

        news(
            "hayat.eskiOyunlar", seasons: [.okul, .yolAyrimi], from: 12, w: 8, cd: .years(4),
            tr: "Eski bir oyun yeniden açıldı; bir saat diye başlandı, gece yarısı bitti.",
            fx: [hp(3), hl(-1)]
        ),

        news(
            "hayat.iyiHaber", seasons: [.yolAyrimi, .kurulus, .ortaSahne, .finalSezonu], w: 8, cd: .years(4),
            tr: "Sevdiğin birinden iyi haber geldi. Kendi gününü de aydınlattı.",
            fx: [hp(3), so(2)]
        ),
    ]
}
