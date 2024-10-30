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
    @Environment(\.colorScheme) var colorScheme
    @Query var categories: [UCCategory]
    @Query var albums: [UCAlbum]
    
    @AppStorage(StorageKeys.isFirstRun.rawValue) var isFirstRun = true
    @AppStorage(StorageKeys.shouldUseMusic.rawValue) var shouldUseMusic = true
    
    @State private var searchText = ""
    @State private var isShowingSettings = false
    @State private var isShowingAddCategory = false
    @State private var isShowingFavorites = false
    @State private var shouldShowAppleMusicError = false
    @State private var selectedCategoryID: UUID? = nil
    @State private var navigationPath = NavigationPath()
    
    @AppStorage(StorageKeys.presetsExpanded.rawValue) private var presetsExpanded = true
    @AppStorage(StorageKeys.userCategoriesExpanded.rawValue) private var userCategoriesExpanded = true
    
    var body: some View {
        if isFirstRun {
            WelcomeView()
        } else {
            NavigationSplitView {
                Group {
                    List(selection: $selectedCategoryID) {
                        DisclosureGroup(isExpanded: $presetsExpanded) {
                            ForEach(
                                categories
                                    .filter({$0.isPreset})
                                    .sorted(by: {$0.name < $1.name})
                            ) { cat in
                                BigPillListRow(category: cat, selectedCategoryID: $selectedCategoryID)
                            }
                        } label: {
                            Text("Preset Categories")
                                .font(.subheadline).fontWeight(.medium).foregroundStyle(.secondary)
                        }
                        .listRowSeparator(.hidden)
                        .disclosureGroupStyle(NoIndentDisclosureStyle())
                        
                        DisclosureGroup(isExpanded: $userCategoriesExpanded) {
                            ForEach(
                                categories
                                    .filter({!$0.isPreset})
                                    .sorted(by: {$0.name < $1.name})
                            ) { cat in
                                BigPillListRow(category: cat, selectedCategoryID: $selectedCategoryID)
                            }
                            
                            // Add button if no user categories exist yet 
                            if categories.filter({!$0.isPreset}).isEmpty {
                                Button {
                                    isShowingAddCategory.toggle()
                                } label: {
                                    Label("Add", systemImage: "plus.circle")
                                        .font(.title3).bold()
                                        .foregroundStyle(colorScheme == .light ? .white : .black)
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            }
                        } label: {
                            Text("My Categories")
                                .font(.subheadline).fontWeight(.medium).foregroundStyle(.secondary)
                        }
                        .listRowSeparator(.hidden)
                        .disclosureGroupStyle(NoIndentDisclosureStyle())
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
                    
                    print("^^ Total categories: \(categories.count)")
                    print("^^ Total albums: \(albums.count)")
                    
//                    try? modelContext.delete(model: UCCategory.self)
//                    try? modelContext.delete(model: UCAlbum.self)
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
                if let selectedCategoryID, let selectedCategory = categories.first(where: {
                    $0.id == selectedCategoryID
                }) {
                    NavigationStack(path: $navigationPath) {
                        CategoryDetailView(
                            category: selectedCategory,
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
