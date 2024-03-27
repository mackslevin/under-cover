//
//  CategoryDetailView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/22/24.
//

import SwiftUI

struct CategoryDetailView: View {
    @Bindable var category: UCCategory
    @State private var rounds: Int = 3
    
    @Environment(SinglePlayerGameController.self) var singlePlayerGameController
    
    
    @State private var isShowingSinglePlayerGame = false
    
    
    
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
                    
                    Button("Setup") {
                        singlePlayerGameController.reset()
                        singlePlayerGameController.category = category
                    }
                    
                    NavigationLink("Start", destination: SinglePlayerGameView())
                }
                .listSectionSeparator(.hidden)
                .sheet(isPresented: $isShowingSinglePlayerGame) {
                    SinglePlayerGameView()
                }
            }
            .navigationTitle(category.name)
        }
    }
}

//#Preview {
//    CategoryDetailView()
//}
