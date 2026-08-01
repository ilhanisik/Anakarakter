import LifeDomain

/// Faz 2 kilometre taşları — hafif, tekrar edilmeyen omurga anları.
enum MilestoneEventsB {
    static let all: [LifeEvent] = [

        milestone(
            "ms.cocukluk.ilkAdim", age: 1,
            tr: "İlk adımlar atıldı! Koltuktan sehpaya tarihi yürüyüş; ev, alkış tribününe döndü.",
            fx: [hp(2)]
        ),

        milestone(
            "ms.orta.kirkYas", age: 40,
            tr: "40. yaş günü: pastada tek rakam mumlar, masada 'hayat yeni başlıyor' esprileri. Hepsi doğru.",
            fx: [hp(2)]
        ),

        milestone(
            "ms.final.yetmisBes", age: 75,
            tr: "75. yaş: mahalle senin çayını içmeye geldi; sandalyeler balkona zor sığdı.",
            fx: [so(3), hp(2)]
        ),
    ]
}
