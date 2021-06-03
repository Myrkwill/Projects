import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet private weak var touchLabel: UILabel! {
        didSet { updateTouches() }
    }
    @IBOutlet private var buttonCollection: [UIButton]!
    
    private lazy var game = СoncentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (buttonCollection.count + 1) / 2
    }
    
    private(set) var toushes = 0 {
        didSet { updateTouches() }
    }
    
//    private var emojiCollection = ["💩", "🐱", "🦁", "🐔", "🐸", "🐻", "🐵", "🐻‍❄️", "🐶"]
    private var emojiCollection = "💩🐱🦁🐔🐸🐻🐵🐻‍❄️🐶"
    private var emojiDictionary = [Card: String]()
    
    @IBAction private func buttonAction(_ sender: UIButton) {
        guard let indexButton = buttonCollection.firstIndex(of: sender) else { return }
        
        toushes += 1
        game.chooseCard(at: indexButton)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(at: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.4564823508, blue: 0.9212636352, alpha: 1)
            }
        }
    }
    
    private func emoji(at card: Card) -> String {
        if emojiDictionary[card] == nil {
            let randomStringIndex = emojiCollection.index(emojiCollection.startIndex, offsetBy: emojiCollection.count.arc4randomExtension)
            emojiDictionary[card] = String(emojiCollection.remove(at: randomStringIndex))
        }
        return emojiDictionary[card] ?? "?"
    }
    
    private func updateTouches() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.red
        ]
        let attributesString = NSAttributedString(string: "Touches: \(toushes)", attributes: attributes)
        touchLabel.attributedText = attributesString
    }
    
}

extension Int {
    
    var arc4randomExtension: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
    
}
