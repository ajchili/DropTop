import Foundation

class Drop: NSObject {
    
    enum type : Int {
        case text = 0
        case link = 1
        case image = 2
        case file = 3
    }
    
    var key: String?
    var title: String?
    var type: Drop.type?
    
    init?(key: String, title: String, type: Drop.type) {
        guard !key.isEmpty || !title.isEmpty else {
            return nil
        }
        
        self.key = key
        self.title = title
        self.type = type
    }
}
