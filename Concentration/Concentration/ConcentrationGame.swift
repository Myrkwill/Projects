import Foundation

struct СoncentrationGame {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "СoncentrationGame.init(\(numberOfPairsOfCards)) must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    mutating func chooseCard(at index: Int) {
        guard !cards[index].isMatched else { return }
        
        if let matchingIndex = indexOfOneAndOnlyFaceUpCard, matchingIndex != index {
            if cards[matchingIndex] == cards[index] {
                cards[matchingIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
            
        } else {
            indexOfOneAndOnlyFaceUpCard = index
        }
    }
    
}

extension Collection {
    
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
    
}
