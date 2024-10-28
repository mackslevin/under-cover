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
    @Environment(\.modelContext) var modelContext
    @Environment(AppleMusicController.self) var appleMusicController
    @Query var categories: [UCCategory]
    @Query var albums: [UCAlbum]
    
    // TODO: Change back 
//    @AppStorage(StorageKeys.isFirstRun.rawValue) var isFirstRun = true
    @AppStorage(StorageKeys.isFirstRun.rawValue) var isFirstRun = false
    
    @AppStorage(StorageKeys.shouldUseMusic.rawValue) var shouldUseMusic = true
    
    @State private var searchText = ""
    @State private var titles: [String] = []
    @State private var isShowingSettings = false
    @State private var isShowingAddCategory = false
    @State private var isShowingFavorites = false
    @State private var shouldShowAppleMusicError = false
    @State private var selectedCategoryID: UUID? = nil
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        if isFirstRun {
            WelcomeView()
        } else {
            NavigationSplitView {
                Group {
                    List(selection: $selectedCategoryID) {
                        ForEach(categories) { cat in
                            BigPillListRow(category: cat, selectedCategoryID: $selectedCategoryID)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    deleteCategoryButton(cat)
                                }
                        }
                    }
                    .listStyle(.plain)
                    
                }
                .navigationTitle("Under Cover")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Settings", systemImage: "gear") {
                            isShowingSettings.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Favorites", systemImage: "list.star") {
                            isShowingFavorites.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add", systemImage: "plus") {
                            isShowingAddCategory.toggle()
                        }
                    }
                }
                .sheet(isPresented: $isShowingSettings, content: { SettingsView() })
                .sheet(isPresented: $isShowingAddCategory, content: { ImportPlaylistView() })
                .sheet(isPresented: $isShowingFavorites, content: { FavoritesIndexView() })
                .onAppear {
                    let fontRegular = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 20)
                    let fontLarge = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 36)
                    UINavigationBar.appearance().titleTextAttributes = [.font: fontRegular!]
                    UINavigationBar.appearance().largeTitleTextAttributes = [.font: fontLarge!, .kern: -1]
                    
                    Task {
                        await appleMusicController.checkAuth()
                        await appleMusicController.getMusicSubscriptionUpdates()
                    }
                }
                .alert(isPresented: $shouldShowAppleMusicError, error: appleMusicController.error) {
                    Button("OK"){}
                }
                .onChange(of: appleMusicController.error) { _, newValue in
                    if let error = newValue {
                        switch error {
                            case .subscriptionRequired(_):
                                if shouldUseMusic { shouldShowAppleMusicError = true }
                            default:
                                shouldShowAppleMusicError = true
                        }
                    }
                }
            } detail: {
                if let selectedCategoryID {
                    NavigationStack(path: $navigationPath) {
                        
                        // TODO: Avoid this force unwrap
                        CategoryDetailView(
                            category: categories.first(where: {
                                $0.id == selectedCategoryID
                            })!,
                            navigationPath: $navigationPath
                        )
                    }
                } else {
                    NavigationStack {
                        ContentUnavailableView("Nothing selected", systemImage: "square.dotted")
                    }
                }
            }
            .fontDesign(.monospaced)
        }
    }
    
    func deleteCategoryButton(_ category: UCCategory) -> some View {
        Button("Delete", systemImage: "trash", role: .destructive) {
            withAnimation {
                selectedCategoryID = nil
                modelContext.delete(category)
                try? modelContext.save()
            }
        }
    }
}

#Preview {
    var container: ModelContainer {
        let previewConfig = ModelConfiguration(isStoredInMemoryOnly: true)
        let previewContainer = try! ModelContainer(for: UCCategory.self , configurations: previewConfig)
        previewContainer.mainContext.insert(UCCategory.testCategory)
        return previewContainer
    }
    
    ContentView()
        .modelContainer(container)
        .environment(AppleMusicController())
}
