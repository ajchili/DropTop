import Foundation

class Drop: NSObject {
    
    enum type {
        case link
        case file
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
