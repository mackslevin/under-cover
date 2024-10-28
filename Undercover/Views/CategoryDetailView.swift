import SwiftUI

struct CategoryDetailView: View {
    @Bindable var category: UCCategory
    @Binding var navigationPath: NavigationPath
    @AppStorage(StorageKeys.singlePlayerRounds.rawValue) private var rounds: Int = 3
    @Environment(SinglePlayerGameController.self) var singlePlayerGameController
    
    
    var body: some View {
        VStack(spacing: 80) {
            if let count = category.albums?.count {
                Text("\(count) albums")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                HStack {
                    Button("Decrease Rounds", systemImage: "minus") {
                        rounds -= 1
                    }
                    .font(.title).bold()
                    .disabled(rounds < 2)
                    
                    Text("\(rounds)")
                        .font(.custom(Font.customFontName, size: 120))
                        .frame(minWidth: 100)
                    
                    Button("Decrease Rounds", systemImage: "plus") {
                        rounds += 1
                    }
                    .font(.title).bold()
                    .disabled(rounds > 9)
                }
                .foregroundStyle(.primary)
                .labelStyle(.iconOnly)
                .sensoryFeedback(.impact, trigger: rounds)
                
                Text("\(rounds > 1 ? "rounds" : "round")")
                    .font(.custom(Font.customFontName, size: 20))
                    .textCase(.uppercase)
            }
            .fontDesign(.none)
             
            Button {
                setUpGame()
                navigationPath.append(category)
            } label: {
                Label("Start", systemImage: "flag.2.crossed")
                    .font(.title).bold()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: UCCategory.self) { _ in
            SinglePlayerGameView()
        }
    }
    
    func setUpGame() {
        singlePlayerGameController.reset()
        singlePlayerGameController.category = category
        singlePlayerGameController.rounds = rounds
    }
}

#Preview {
    CategoryDetailView(category: UCCategory(name: "Something Cool", albums: []), navigationPath: .constant(NavigationPath()))
        .environment(SinglePlayerGameController())
        .fontDesign(.monospaced)
        .onAppear {
            let fontRegular = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 20)
            let fontLarge = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 36)
            UINavigationBar.appearance().titleTextAttributes = [.font: fontRegular!]
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: fontLarge!]
        }
}
