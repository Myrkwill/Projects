import Foundation

struct Card {
    
    private var id: Int
    var isFaceUp = false
    var isMatched = false
    
    private static var identifier = 0
    
    private static func identifierGenerator() -> Int {
        identifier += 1
        return identifier
    }
    
    init() {
        id = Card.identifierGenerator()
    }
    
}

extension Card: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
}
