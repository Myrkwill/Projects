import SwiftUI

struct CardView: View {
    
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Image(systemName: card.iconName)
                        .foregroundColor(Color(.systemBlue))
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBlue))
                                .opacity(0.1)
                        )
                    Spacer()
                }
                Text(card.title)
                    .font(.custom("Avenir-Heavy", size: 22))
                Text(card.subtitle)
                    .modifier(CardDetailTextStyle())
                
                if let percentageText = card.percentageText {
                    HStack {
                        Text(percentageText)
                            .modifier(CardDetailTextStyle())
                        Spacer()
                        ProgressView(value: card.percentageComplete, total: 100)
                            .progressViewStyle(MeditationProgressViewStyle())
                    }
                }
            }
            .padding()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = Card(
            iconName: "moon",
            title: "The Silent Night Vibes",
            subtitle: "2/4 Session left",
            percentageComplete: 75
        )
        CardView(card: card).fixedSize(horizontal: false, vertical: true)
    }
}
