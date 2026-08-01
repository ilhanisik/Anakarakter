import LifeDomain

/// İsim ve mahalle havuzları. Mahalleler kurgusaldır — gerçek kurum/marka
/// ismi kullanılmaz (İçerik Çizgisi).
enum PersonPoolsContent {
    static let pools = PersonPools(
        femaleNames: [
            "Ayşe", "Fatma", "Zeynep", "Elif", "Merve", "Selin", "Ece", "Aslı",
            "Buse", "Gamze", "İrem", "Melis", "Nazlı", "Pelin", "Seda", "Tuğçe",
            "Yasemin", "Ceren", "Derya", "Esra", "Hande", "Sevgi", "Feride", "Nehir",
        ],
        maleNames: [
            "Mehmet", "Ahmet", "Mustafa", "Emre", "Burak", "Can", "Cem", "Efe",
            "Kerem", "Mert", "Onur", "Ozan", "Serkan", "Tolga", "Umut", "Volkan",
            "Yiğit", "Barış", "Doruk", "Eren", "Furkan", "Hakan", "Kaan", "Selim",
        ],
        neighborhoods: [
            "Gülbahar Mahallesi", "Çınaraltı", "Menekşe Mahallesi", "Taşköprü",
            "Kirazlıbağ", "Yıldıztepe", "Söğütlü Mahalle", "Papatya Sokak",
            "Kavaklı Meydan", "Zeytinlik", "Fenerli Sokak", "Aygün Mahallesi",
            "Serin Vadi", "Bahar Sitesi", "Demirciler Yokuşu", "Yalı Sokak",
        ]
    )
}
