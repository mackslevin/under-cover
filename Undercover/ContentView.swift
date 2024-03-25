//
//  ContentView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/21/24.
//

import SwiftUI
import SwiftData
import MusicKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var titles: [String] = []
    @State private var isAuthorized = false
    @State private var isShowingSettings = false
    @Query var categories: [UCCategory]
    @State private var selectedCategoryID: UUID? = nil
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedCategoryID) {
                ForEach(categories) { cat in
                    Text(cat.name)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                withAnimation {
                                    modelContext.delete(cat)
                                }
                            }
                        }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem {
                    Button("Settings", systemImage: "gear") {
                        isShowingSettings.toggle()
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings, content: { SettingsView() })
        } detail: {
            if let selectedCategoryID {
                NavigationStack {
                    CategoryDetailView(
                        category: categories.first(where: {
                            $0.id == selectedCategoryID
                        })!
                    )
                }
            } else {
                NavigationStack {
                    ContentUnavailableView("Nothing selected", systemImage: "square.dotted")
                }
            }
        }

    }
    
    
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
