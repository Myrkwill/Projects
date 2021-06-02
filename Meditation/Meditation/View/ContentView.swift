import SwiftUI

struct ContentView: View {
    
    @State var searchText = ""
    let inProgressCard = Card(
        iconName: "moon",
        title: "The Silent Night Vibes",
        subtitle: "2/4 Session left",
        percentageComplete: 75
    )
    
    let recommendedCards: [Card] = [
        .init(iconName: "face.smiling", title: "Happiness and Joyful", subtitle: "4 Sessions", percentageComplete: nil),
        .init(iconName: "heart", title: "Lovely and Vibes", subtitle: "5 Sessions", percentageComplete: nil)
    ]
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemGroupedBackground
    }
    
    var searchView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemGray5))
                .frame(height: 50)
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(.systemGray4))
                    .padding(.horizontal, 20)
                TextField("Search themes here", text: $searchText)
                    .font(.custom("Avenir-Medium", size: 16))
                Image(systemName: "mic")
                    .resizable()
                    .frame(width: 20, height: 25)
                    .foregroundColor(Color(.systemRed))
                    .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    var inProgressSectionView: some View {
        HStack {
            Text("In Progress")
                .font(.custom("Avenir-Heavy", size: 18))
            Spacer()
        }
        CardView(card: inProgressCard)
    }
    
    @ViewBuilder
    var recommendedSectionView: some View {
        HStack {
            Text("Recommended")
                .font(.custom("Avenir-Heavy", size: 18))
            Spacer()
            Image(systemName: "arrow.right")
                .foregroundColor(Color(.systemBlue))
        }
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(recommendedCards, id: \.self) { card in
                    CardView(card: card)
                        .frame(width: 200)
                }
            }
        }
    }
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Welcome Back")
                    .font(.custom("Avenir-Heavy", size: 30))
                Text("Ready to start your day?")
                    .modifier(CardDetailTextStyle())
                searchView
                inProgressSectionView
                recommendedSectionView
            }
            .padding(24)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button {
            
        } label: {
            Image(systemName: "list.bullet")
        }, trailing: Button {
            
        } label: {
            Image(systemName: "bell")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
        .accentColor(.primary)
    }
}
