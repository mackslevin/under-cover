import SwiftUI

struct CategoryDetailView: View {
    @Bindable var category: UCCategory
    @Binding var navigationPath: NavigationPath
    @AppStorage("spRounds") private var rounds: Int = 3
    @Environment(SinglePlayerGameController.self) var singlePlayerGameController
    
    
    var body: some View {
            List {
                if let count = category.albums?.count {
                    Text("\(count) albums")
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .font(.title3)
                }
                
                Section {
                    Stepper("\(rounds) \(rounds > 1 ? "rounds" : "round")", value: $rounds, in: 3...9)
                    
                }
                .listSectionSeparator(.hidden)
                
                Button {
                    setUpGame()
                    navigationPath.append(category)
                } label: {
                    Label("Start", systemImage: "flag.2.crossed")
                }
            }
            
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

//#Preview {
//    CategoryDetailView(category: UCCategory(name: "Something Cool", albums: []))
//        .environment(SinglePlayerGameController())
//        .fontDesign(.monospaced)
//        .onAppear {
//            let fontRegular = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 20)
//            let fontLarge = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 36)
//            UINavigationBar.appearance().titleTextAttributes = [.font: fontRegular!]
//            UINavigationBar.appearance().largeTitleTextAttributes = [.font: fontLarge!]
//        }
//}
