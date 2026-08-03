import LifeDomain

/// Çocukluk (0–5) — Faz 2 genişletmesi.
enum ChildhoodEventsB {
    static let all: [LifeEvent] = [

        decision(
            "cocukluk.disDoktoru", seasons: [.cocukluk], from: 3, w: 10,
            tr: "İlk diş doktoru randevusu. Bekleme salonundaki balık akvaryumu bile gerginliği çözemedi.",
            choices: [
                choice("cocukluk.disDoktoru", "kucak", .safe,
                    tr: "Anne kucağında metanet",
                    outcomes: [
                        outcome("cocukluk.disDoktoru", "kucak", 1,
                            tr: "Sıkı tutundun, iş bitti. Çıkışta dondurma diplomasi olarak verildi.",
                            fx: [hl(1)]),
                    ]),
                choice("cocukluk.disDoktoru", "tekBasina", .bold,
                    tr: "Koltuğa tek başına otur",
                    outcomes: [
                        outcome("cocukluk.disDoktoru", "tekBasina", 1, w: 2,
                            tr: "Kahraman ilan edildin; çıkartma ödülü yakaya takıldı.",
                            fx: [hp(4)]),
                        outcome("cocukluk.disDoktoru", "tekBasina", 2,
                            tr: "Koltuk yukarı kalkınca moral aşağı indi. Yine de bitti.",
                            fx: [hp(-2)]),
                    ]),
            ]
        ),

        decision(
            "cocukluk.evcilHayvan", seasons: [.cocukluk], from: 4, w: 10,
            tr: "Sokakta bir yavru kedi peşine takıldı. Gözler buluştu; iş ciddi.",
            choices: [
                choice("cocukluk.evcilHayvan", "besle", .safe,
                    tr: "Kapı önünde besle",
                    outcomes: [
                        outcome("cocukluk.evcilHayvan", "besle", 1,
                            tr: "Artık her akşam kapıda seni bekliyor; mahalle kedisi ama kalbi senin.",
                            fx: [hp(2)]),
                    ]),
                choice("cocukluk.evcilHayvan", "eveAl", .bold,
                    tr: "Eve al ('sadece bir gecelik' klasiği)",
                    outcomes: [
                        outcome("cocukluk.evcilHayvan", "eveAl", 1,
                            tr: "Kısa bir aile zirvesi, sonra herkes âşık. Kedi artık evin gerçek sahibi.",
                            fx: [hp(6), flag(.evcilDost)]),
                        outcome("cocukluk.evcilHayvan", "eveAl", 2,
                            tr: "Baban 'olmaz' dedi; kedi komşuya yerleşti. Ziyaret hakkı sende saklı.",
                            fx: [hp(-3)]),
                    ]),
            ]
        ),

        decision(
            "cocukluk.ilkBisiklet", seasons: [.cocukluk], from: 4, w: 10,
            tr: "Bisikletin destek tekerleri sökülme günü geldi. Sokak seyirci topladı.",
            choices: [
                choice("cocukluk.ilkBisiklet", "birHafta", .safe,
                    tr: "Bir hafta daha kalsın",
                    outcomes: [
                        outcome("cocukluk.ilkBisiklet", "birHafta", 1,
                            tr: "Sakin sakin alıştın; dengen gün gün oturdu.",
                            fx: [hl(1)]),
                    ]),
                choice("cocukluk.ilkBisiklet", "sok", .bold,
                    tr: "Sök gitsin; tutmadan bırakın",
                    outcomes: [
                        outcome("cocukluk.ilkBisiklet", "sok", 1, w: 2,
                            tr: "SÜRDÜN! Sokak alkışladı, sen dünyanın en hızlı insanıydın.",
                            fx: [hp(5)]),
                        outcome("cocukluk.ilkBisiklet", "sok", 2,
                            tr: "İlk viraj, ilk yara bandı. Gözyaşı kısa, hikâye uzun sürdü.",
                            fx: [hl(-3)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.pazarSabahi", seasons: [.cocukluk], w: 10, cd: .years(3),
            tr: "Pazar sabahı: ev poğaça kokuyor, radyoda eski şarkılar. Kimsenin acelesi yok.",
            fx: [hp(2)]
        ),

        decision(
            "cocukluk.anaokulGosterisi", seasons: [.cocukluk], from: 4, w: 10,
            tr: "Anaokulu yıl sonu gösterisi: sana 'ağaç' rolü verildi. Repliğin yok, duruşun var.",
            choices: [
                choice("cocukluk.anaokulGosterisi", "agac", .safe,
                    tr: "Ağaç ol, sağlam dur",
                    outcomes: [
                        outcome("cocukluk.anaokulGosterisi", "agac", 1,
                            tr: "Sahnenin en kararlı ağacı sendin; veliler dallarına hayran kaldı.",
                            fx: [so(1)]),
                    ]),
                choice("cocukluk.anaokulGosterisi", "replik", .bold,
                    tr: "Repliksiz role replik yaz",
                    outcomes: [
                        outcome("cocukluk.anaokulGosterisi", "replik", 1,
                            tr: "'Ben konuşan ağacım!' Salon yıkıldı; öğretmen pes edip güldü.",
                            fx: [so(5)]),
                        outcome("cocukluk.anaokulGosterisi", "replik", 2,
                            tr: "Şşşt'lendin ve ağaçlığa geri döndün. Sanat tarihi seni yazacak.",
                            fx: [so(-3)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.dedeAnneanne", seasons: [.cocukluk], w: 10, cd: .years(2),
            tr: "Dede/anneanne ziyareti: harçlık usulca cebe sıkıştırıldı, nasihat açıkça kulağa söylendi.",
            fx: [hp(2), tl(500)]
        ),

        decision(
            "cocukluk.yagmurdaOyun", seasons: [.cocukluk], from: 3, w: 10,
            tr: "Sağanak başladı; sokakta su birikintileri parlıyor. Pencere mi, çamur mu?",
            choices: [
                choice("cocukluk.yagmurdaOyun", "cam", .safe,
                    tr: "Camdan izle",
                    outcomes: [
                        outcome("cocukluk.yagmurdaOyun", "cam", 1,
                            tr: "Cam buğulandı, sen resim çizdin. İçerisi de fena değilmiş.",
                            fx: [hp(1)]),
                    ]),
                choice("cocukluk.yagmurdaOyun", "camur", .bold,
                    tr: "Çamura dal",
                    outcomes: [
                        outcome("cocukluk.yagmurdaOyun", "camur", 1, w: 2,
                            tr: "Efsane bir oyun çıktı; çamaşır makinesi gece mesaisine kaldı.",
                            fx: [hp(4)]),
                        outcome("cocukluk.yagmurdaOyun", "camur", 2,
                            tr: "Üşüttün; bir hafta limonlu çay ve battaniye nöbeti.",
                            fx: [hl(-3)]),
                    ]),
            ]
        ),

        news(
            "cocukluk.kayipDis", seasons: [.cocukluk, .okul], from: 5, to: 7, w: 10,
            tr: "İlk diş düştü! Yastık altı ekonomisiyle tanıştın; kur sabit: bir diş, bir sevinç.",
            fx: [hp(1), tl(100)]
        ),

        news(
            "cocukluk.ilkFotograf", seasons: [.cocukluk], to: 3, w: 8,
            tr: "Aile albümüne ilk stüdyo fotoğrafı girdi: herkes çok ciddi, sen şaşkın, fon gökkuşağı.",
            fx: [hp(1)]
        ),
    ]
}
