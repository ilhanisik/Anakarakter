import Foundation
import LifeDomain

extension EventText {
    /// Olay metnini çözer: String Catalog'da bu anahtar için çeviri varsa onu,
    /// yoksa içerikteki Türkçe kaynak metni döndürür (yerelleştirilebilir şema —
    /// docs/02 karar günlüğü). MVP'de olay içeriği Türkçe'dir.
    var resolved: String {
        Bundle.main.localizedString(forKey: key, value: tr, table: nil)
    }
}
