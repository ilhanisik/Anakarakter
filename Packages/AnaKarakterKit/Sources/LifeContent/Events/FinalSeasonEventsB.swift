import LifeDomain

/// Final Sezonu (65+) — Faz 2 genişletmesi.
enum FinalSeasonEventsB {
    static let all: [LifeEvent] = [

        news(
            "final.sabahYuruyusu", seasons: [.finalSezonu], w: 10, cd: .years(3),
            tr: "Sabah yürüyüşü rotası sabitlendi: fırın, park, simitçi, eve dönüş. Rota kutsaldır.",
            fx: [hl(2), hp(1)]
        ),

        news(
            "final.torunMasal", seasons: [.finalSezonu], w: 10,
            cond: [.hasFlag(.torunVar)], cd: .years(2),
            tr: "Torunlara masal saati: senin uydurduğun kahraman artık aile klasiği oldu.",
            fx: [hp(3)]
        ),

        news(
            "final.eskiRadyo", seasons: [.finalSezonu], w: 8, cd: .years(4),
            tr: "Eski radyo tamir edildi; biraz parazitli ama o şarkılar aynı şarkılar.",
            fx: [hp(2)]
        ),

        news(
            "final.gencKomsu", seasons: [.finalSezonu], w: 10, cd: .years(3),
            tr: "Genç komşu poşetlerini kapına bırakmış; sen de karşılık olarak çorba gönderdin. Mahalle böyle döner.",
            fx: [so(2), hp(1)]
        ),

        decision(
            "final.hatiraDefteri", seasons: [.finalSezonu], w: 10,
            tr: "Kırtasiyeden kalın bir defter aldın; kapağına 'Hayatım' yazmak üzeresin.",
            choices: [
                choice("final.hatiraDefteri", "yaz", .neutral,
                    tr: "Kendin yaz",
                    outcomes: [
                        outcome("final.hatiraDefteri", "yaz", 1,
                            tr: "Her akşam bir sayfa; bazı sayfalar gülümseten, bazıları sessiz.",
                            fx: [hp(3), rol("tarihci", "Aile tarihçisi")]),
                    ]),
                choice("final.hatiraDefteri", "anlat", .neutral,
                    tr: "Sen anlat, gençler yazsın",
                    outcomes: [
                        outcome("final.hatiraDefteri", "anlat", 1,
                            tr: "Kayıt başladı: 'Bir de şu vardı...' — arşiv büyüyor, kahkaha eksilmiyor.",
                            fx: [so(2), hp(1)]),
                    ]),
            ]
        ),

        decision(
            "final.bahceKomitesi", seasons: [.finalSezonu], w: 8, cd: .years(4),
            tr: "Mahalle bahçe komitesi kuruluyor; isminin geçtiği duyuldu.",
            choices: [
                choice("final.bahceKomitesi", "koordinator", .neutral,
                    tr: "Koordinatörlüğü üstlen",
                    outcomes: [
                        outcome("final.bahceKomitesi", "koordinator", 1,
                            tr: "Fide takvimi, sulama nöbeti, hasat şenliği: bahçe senin sahnende yeşerdi.",
                            fx: [so(3), rol("bahcivan", "Mahalle bahçıvanı")]),
                    ]),
                choice("final.bahceKomitesi", "sponsor", .neutral,
                    tr: "Fide sponsoru ol, kenardan destekle",
                    outcomes: [
                        outcome("final.bahceKomitesi", "sponsor", 1,
                            tr: "Senin fideler domates verdi; komite ilk tabağı sana gönderdi.",
                            fx: [hp(2), tl(-2_000)]),
                    ]),
            ]
        ),

        news(
            "final.eskiDostCayi", seasons: [.finalSezonu], w: 8,
            cond: [.hasFlag(.kanka)], cd: .years(3),
            tr: "Kankanla haftalık çay günü kuruldu; gündem altmış yıl öncesi, çay hep taze.",
            fx: [hp(3), so(1)]
        ),

        news(
            "final.patiliDost", seasons: [.finalSezonu], w: 8,
            cond: [.hasFlag(.evcilDost)], cd: .years(5),
            tr: "Albümde o patili dostun fotoğrafı çıktı; adı geçince ev hâlâ gülümsüyor.",
            fx: [hp(2)]
        ),

        news(
            "final.yilbasiTombala", seasons: [.finalSezonu], w: 10, cd: .years(3),
            tr: "Yılbaşı gecesi aile tombalası: çinko sesleri, mandalina kokusu, kaybederken bile kazanılan bir akşam.",
            fx: [hp(2), so(1)]
        ),
    ]
}
