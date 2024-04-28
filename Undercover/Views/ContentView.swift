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
    @AppStorage(StorageKeys.isFirstRun.rawValue) var isFirstRun = true
    
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
                    if categories.isEmpty {
                        NoCategoriesView(isShowingAddCategory: $isShowingAddCategory)
                    } else {
                        List(selection: $selectedCategoryID) {
                            ForEach(categories) { cat in
                                BigPillListRow(category: cat, selectedCategoryID: $selectedCategoryID)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button("Delete", systemImage: "trash", role: .destructive) {
                                            withAnimation {
                                                selectedCategoryID = nil
                                                
                                                // Delete only the category albums which are *not* favorited
                                                if let albums = cat.albums {
                                                    for album in albums {
                                                        if !album.isFavorited {
                                                            modelContext.delete(album)
                                                        }
                                                    }
                                                }
                                                
                                                modelContext.delete(cat)
                                            }
                                        }
                                    }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                .navigationTitle("Categories")
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
                .onChange(of: appleMusicController.error) { _, _ in
                    shouldShowAppleMusicError = true
                }
            } detail: {
                if let selectedCategoryID {
                    NavigationStack(path: $navigationPath) {
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
}

//#Preview {
//    ContentView()
//        .modelContainer(for: [UCCategory.self])
//}
