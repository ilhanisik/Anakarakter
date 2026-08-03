import LifeDomain

/// Yol Ayrımı (18–24) — Faz 2 genişletmesi.
enum CrossroadsEventsB {
    static let all: [LifeEvent] = [

        news(
            "yol.yurtYemekhane", seasons: [.yolAyrimi], to: 21, w: 10,
            cond: [.hasFlag(.universiteli)], cd: .years(2),
            tr: "Yemekhanede efsane gün: tavuklu pilav. Kuyruk kapıya taştı, moral tavana vurdu.",
            fx: [hp(1)]
        ),

        decision(
            "yol.dersNotlari", seasons: [.yolAyrimi], w: 10,
            cond: [.hasFlag(.universiteli)],
            tr: "Final haftası: notlar dağınık, kantin dolu, herkes aynı soruda.",
            choices: [
                choice("yol.dersNotlari", "kamp", .safe,
                    tr: "Kütüphane kampı kur",
                    outcomes: [
                        outcome("yol.dersNotlari", "kamp", 1,
                            tr: "Sabah dokuz akşam dokuz; finaller temiz geçti.",
                            fx: [iq(3)]),
                    ]),
                choice("yol.dersNotlari", "ag", .bold,
                    tr: "Not paylaşım ağı kur — herkes sana borçlansın",
                    outcomes: [
                        outcome("yol.dersNotlari", "ag", 1, w: 2,
                            tr: "Ağ çalıştı! Notlar da yükseldi, itibar da; kantinde çaylar senden sorulmaz oldu.",
                            fx: [iq(3), so(3)]),
                        outcome("yol.dersNotlari", "ag", 2,
                            tr: "Yanlış PDF'ler dolaşıma girdi; gece yarısı panik mesajları sana geldi.",
                            fx: [so(-4), iq(1)]),
                    ]),
            ]
        ),

        news(
            "yol.ilkMaasGunu", seasons: [.yolAyrimi], from: 20, w: 10,
            cond: [.hasFlag(.calisiyor)],
            tr: "İlk maaş hesaba yattı; bildirime beş kez baktın, beşinde de oradaydı.",
            fx: [hp(3), tl(5_000)]
        ),

        decision(
            "yol.gencGezi", seasons: [.yolAyrimi], w: 10,
            tr: "Arkadaş grubunda düşük bütçeli tren gezisi planı dönüyor; harita masada.",
            choices: [
                choice("yol.gencGezi", "biriktir", .safe,
                    tr: "Bu sefer katılma; biriktir",
                    outcomes: [
                        outcome("yol.gencGezi", "biriktir", 1,
                            tr: "Fotoğraflara içlenerek baktın ama kumbara teşekkür etti.",
                            fx: [iq(1)]),
                    ]),
                choice("yol.gencGezi", "cantayiKap", .bold,
                    tr: "Sırt çantanı kap",
                    outcomes: [
                        outcome("yol.gencGezi", "cantayiKap", 1, w: 2,
                            tr: "Üç şehir, bin fotoğraf, bir ömürlük iç hikâye arşivi.",
                            fx: [hp(5), so(2), tl(-8_000)]),
                        outcome("yol.gencGezi", "cantayiKap", 2,
                            tr: "Bütçe ikinci gün bitti; dönüş epik ama menü sadece simit.",
                            fx: [hp(-2), tl(-8_000)]),
                    ]),
            ]
        ),

        news(
            "yol.kampusKedisi", seasons: [.yolAyrimi], w: 10,
            cond: [.hasFlag(.universiteli)], cd: .years(3),
            tr: "Kampüs kedisi derste ön sırayı kaptı; yoklamada 'burada' sayıldı, kimse itiraz etmedi.",
            fx: [hp(2)]
        ),

        decision(
            "yol.yabanciDil", seasons: [.yolAyrimi], w: 10,
            tr: "Yabancı dil hedefi masada: uygulama mı, konuşma kulübü mü?",
            choices: [
                choice("yol.yabanciDil", "uygulama", .safe,
                    tr: "Uygulamayla günlük pratik",
                    outcomes: [
                        outcome("yol.yabanciDil", "uygulama", 1,
                            tr: "Seri bozulmadı; baykuş seninle gurur duyuyor.",
                            fx: [iq(2)]),
                    ]),
                choice("yol.yabanciDil", "kulup", .bold,
                    tr: "Konuşma kulübünde sahneye çık",
                    outcomes: [
                        outcome("yol.yabanciDil", "kulup", 1,
                            tr: "Akıcılık sıçradı; yabancı öğrencilerle kahve grubu kuruldu.",
                            fx: [so(4), iq(1)]),
                        outcome("yol.yabanciDil", "kulup", 2,
                            tr: "İlk cümlede kilitlendin; kulüp alkışla destekledi, ikinci hafta daha iyiydi.",
                            fx: [so(-3), iq(1)]),
                    ]),
            ]
        ),

        decision(
            "yol.kariyerFuari", seasons: [.yolAyrimi], from: 21, w: 10,
            tr: "Kariyer fuarı: standlar, broşürler ve 'kendinizden bahseder misiniz?' provaları.",
            choices: [
                choice("yol.kariyerFuari", "cvTuru", .safe,
                    tr: "CV dağıt, standları gez",
                    outcomes: [
                        outcome("yol.kariyerFuari", "cvTuru", 1,
                            tr: "Dört stand, dört görüşme sözü; çanta broşür dolu, kafa net.",
                            fx: [iq(2)]),
                    ]),
                choice("yol.kariyerFuari", "soru", .bold,
                    tr: "Panel konuşmacısına soru sor, kartını iste",
                    outcomes: [
                        outcome("yol.kariyerFuari", "soru", 1, w: 2,
                            tr: "Soru yerinde, kart cepte; 'bize yazın' dendi ve ciddiydi.",
                            fx: [so(4), iq(1)]),
                        outcome("yol.kariyerFuari", "soru", 2,
                            tr: "Soru üç dakika sürdü; salondan 'toparla' bakışları geldi.",
                            fx: [so(-3)]),
                    ]),
            ]
        ),

        news(
            "yol.evOzlemi", seasons: [.yolAyrimi], w: 10, cd: .years(2),
            tr: "Anneden kargo geldi: kavanozlar, örgü çorap ve 'kendine iyi bak' notu. Gözler doldu.",
            fx: [hp(3)]
        ),

        decision(
            "yol.sporTakimi", seasons: [.yolAyrimi], w: 10,
            tr: "Mahallenin amatör takımı kadro tamamlıyor; antrenman salı-perşembe.",
            choices: [
                choice("yol.sporTakimi", "seyirci", .safe,
                    tr: "Maçları tribünden takip et",
                    outcomes: [
                        outcome("yol.sporTakimi", "seyirci", 1,
                            tr: "Takımın on ikinci oyuncusu ilan edildin; sesin hiç kısılmadı sayılır.",
                            fx: [so(1)]),
                    ]),
                choice("yol.sporTakimi", "lige", .bold,
                    tr: "Kadroya yazıl",
                    outcomes: [
                        outcome("yol.sporTakimi", "lige", 1, w: 2,
                            tr: "İlk sezonda as oyuncu oldun; forma numaran artık senin.",
                            fx: [hl(4), so(2)]),
                        outcome("yol.sporTakimi", "lige", 2,
                            tr: "İlk antrenman sonrası merdiven inmek üç gün sürdü.",
                            fx: [hl(-3)]),
                    ]),
            ]
        ),

        decision(
            "yol.esnafYardimi", seasons: [.yolAyrimi], w: 10,
            tr: "Mahalle esnafı yaz sezonu için güvenilir bir yardımcı arıyor; ilk akla gelen sensin.",
            choices: [
                choice("yol.esnafYardimi", "tezgah", .neutral,
                    tr: "Tezgâhta çalış",
                    outcomes: [
                        outcome("yol.esnafYardimi", "tezgah", 1,
                            tr: "Yaz boyu esnaf muhabbeti + emeğinin karşılığı. Terazi artık dostun.",
                            fx: [so(2), tl(15_000)]),
                    ]),
                choice("yol.esnafYardimi", "vakitYok", .neutral,
                    tr: "Bu yaz olmaz; programın dolu",
                    outcomes: [
                        outcome("yol.esnafYardimi", "vakitYok", 1,
                            tr: "Nazikçe teşekkür ettin; esnaf 'kısmet' dedi, çay yine ikram edildi.",
                            fx: [iq(1)]),
                    ]),
            ]
        ),

        decision(
            "yol.konser", seasons: [.yolAyrimi], w: 10,
            tr: "Sevdiğin grup şehre geliyor; bilet fiyatı görülünce kısa bir sessizlik yaşandı.",
            choices: [
                choice("yol.konser", "yayin", .safe,
                    tr: "Evde canlı yayından izle",
                    outcomes: [
                        outcome("yol.konser", "yayin", 1,
                            tr: "Battaniye + çay + yayın: konforlu bir konser deneyimi.",
                            fx: [hp(1)]),
                    ]),
                choice("yol.konser", "onSira", .bold,
                    tr: "Ön sıra bileti al",
                    outcomes: [
                        outcome("yol.konser", "onSira", 1, w: 2,
                            tr: "Sesin kısıldı, ruhun şarj oldu; o şarkıda oradaydın.",
                            fx: [hp(5), tl(-6_000)]),
                        outcome("yol.konser", "onSira", 2,
                            tr: "Sağanak + iptal; iade haftalar sürdü, hikâye anında yayıldı.",
                            fx: [hp(-3), tl(-6_000)]),
                    ]),
            ]
        ),

        decision(
            "yol.donemProjesi", seasons: [.yolAyrimi], from: 19, w: 10,
            cond: [.hasFlag(.universiteli)],
            tr: "Dönem projesi konusu seçilecek; hocanın 'iddialı olan var mı?' bakışı sınıfı taradı.",
            choices: [
                choice("yol.donemProjesi", "kanitli", .safe,
                    tr: "Kanıtlanmış klasik bir konu seç",
                    outcomes: [
                        outcome("yol.donemProjesi", "kanitli", 1,
                            tr: "Temiz literatür, temiz rapor, temiz not.",
                            fx: [iq(2)]),
                    ]),
                choice("yol.donemProjesi", "denenmemis", .bold,
                    tr: "Kimsenin denemediği konuya gir",
                    outcomes: [
                        outcome("yol.donemProjesi", "denenmemis", 1,
                            tr: "Hoca sunum sonrası 'bunu yayınlayalım' dedi. Sınıfta kısa bir sessizlik, sonra alkış.",
                            fx: [iq(6), rol("arastirmaci", "Meraklı araştırmacı")]),
                        outcome("yol.donemProjesi", "denenmemis", 2,
                            tr: "Deney çöktü; rapor 'çıkarılan dersler' bölümünün gücüyle kurtarıldı.",
                            fx: [iq(-2)]),
                    ]),
            ]
        ),
    ]
}
