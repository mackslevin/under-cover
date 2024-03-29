//
//  CategoryDetailView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/22/24.
//

import SwiftUI

struct CategoryDetailView: View {
    @Bindable var category: UCCategory
    @AppStorage("spRounds") private var rounds: Int = 3
    @Environment(SinglePlayerGameController.self) var singlePlayerGameController
    @State private var isShowingSinglePlayerGame = false
    @AppStorage("numberOfOptions") private var numberOfOptions: Int = 3
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if let count = category.albums?.count {
                        Text("\(count) albums")
                    }
                }
                .listSectionSeparator(.hidden)
                
                Section("Single Player") {
                    Stepper("\(rounds) \(rounds > 1 ? "rounds" : "round")", value: $rounds, in: 3...9)
                    Stepper("\(numberOfOptions) \(numberOfOptions < 1 ? "option" : "options")", value: $numberOfOptions, in: 2...5)
                }
                .listSectionSeparator(.hidden)
                .sheet(isPresented: $isShowingSinglePlayerGame) {
                    SinglePlayerGameView()
                }
            }
            .navigationTitle(category.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SinglePlayerGameView()
                    } label: {
                        Label("Start", systemImage: "flag.2.crossed")
                    }
                }
            }
            .onAppear {
                setUpForSinglePlayer()
            }
            .onChange(of: rounds) { _, _ in
                setUpForSinglePlayer()
            }
        }
    }
    
    func setUpForSinglePlayer() {
        singlePlayerGameController.reset()
        singlePlayerGameController.category = category
        singlePlayerGameController.rounds = rounds
        singlePlayerGameController.numberOfOptions = numberOfOptions
    }
}

//#Preview {
//    CategoryDetailView()
//}
