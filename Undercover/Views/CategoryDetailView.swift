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
                    Button("Start") {
                        
                    }
                    .bold()
                }
                .listSectionSeparator(.hidden)
            }
            .navigationTitle(category.name)
        }
    }
}

//#Preview {
//    CategoryDetailView()
//}
