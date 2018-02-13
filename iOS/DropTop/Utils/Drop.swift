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
    var data: String?
    var type: Drop.type?
    
    init?(key: String, title: String, data: String, type: Drop.type) {
        guard !key.isEmpty || !data.isEmpty || !title.isEmpty else {
            return nil
        }
        
        self.key = key
        self.title = title
        self.data = data
        self.type = type
    }
}
