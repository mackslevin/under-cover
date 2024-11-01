//
//  ScoreboardView.swift
//  Undercover
//
//  Created by Mack Slevin on 4/22/24.
//

import SwiftUI
import SwiftData

struct ScoreboardView: View {
    @State var scores: [UCHiScoreEntry]
    let currentGameScore: UCHiScoreEntry
    
    @Environment(\.modelContext) var modelContext
    @State private var isShowingScoreDeletionConfirmation = false
    @State private var isShowingInfo = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Scoreboard")
                    .fontWeight(.black)
                    .textCase(.uppercase)
                    .tracking(1.4)
                    .padding(.leading, 20)
                
                Image(systemName: "info.circle")
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                    .accessibilityLabel("Scoreboard info")
                    .onTapGesture {
                        isShowingInfo.toggle()
                    }
                    .popover(isPresented: $isShowingInfo, attachmentAnchor: .point(UnitPoint.topTrailing), arrowEdge: .top, content: {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("About Hi Scores")
                                    .fontDesign(.none)
                                    .font(.custom(Font.customFontName, size: 24))
                                Text(Utility.hiScoresExplainer)
                                    .presentationDetents([.medium])
                            }
                            .padding()
                        }
                    })
                    
                    
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical)
            .background {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundStyle(.ultraThinMaterial)
                    Rectangle().frame(height: 1)
                        .padding(.horizontal, 1) // Accounting for outer stroke
                }
            }
            
            ScrollView {
                Rectangle().opacity(0).frame(height: 8) // Hacky inner padding
                VStack {
                    ForEach(scores.sorted(using: SortDescriptor(\.score, order: .reverse))) { scoreEntry in
                        HStack(spacing: 12) {
                            Text("\(positionOf(scoreEntry, within: scores))")
                                .padding(14)
                                .font(.title)
                                .fontWeight(.light)
                                .background {
                                    Circle()
                                        .stroke()
                                        .opacity(currentGameScore.id == scoreEntry.id ? 0 : 1)
                                }
                            
                            VStack(alignment: .leading) {
                                Text("\(scoreEntry.score) pts")
                                    .font(.title3)
                                    .fontWeight(.black)
                                Text(currentGameScore.id == scoreEntry.id ? "Just now" : scoreEntry.date.formatted())
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background {
                            if currentGameScore.id == scoreEntry.id {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.accentColor)
                                        .shadow(radius: 2, x: 1, y: 2)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke()
                                }
                            }
                        }
                        
                    }
                }
                .padding(.horizontal, 3) // Account for stroke and shadow positioning
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .frame(height: 300)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            VStack(spacing: 0) {
                Spacer()
                Rectangle().frame(height: 1)
                    .padding(.horizontal, 1) // Accounting for outer stroke
                ZStack {
                    Rectangle()
                        .frame(maxHeight: 50)
                        .foregroundStyle(.ultraThinMaterial)
                    HStack {
                        Button("Clear", systemImage: "xmark") {
                            isShowingScoreDeletionConfirmation.toggle()
                        }
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleOnly)
                        .font(.caption)
                        .disabled(scores.isEmpty)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 40)
                .stroke().padding(1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .confirmationDialog("Are you sure you want to delete all these scores?", isPresented: $isShowingScoreDeletionConfirmation) {
            Button("Delete All These Cool Scores", role: .destructive) {
                let toDelete = scores
                
                withAnimation {
                    scores = []
                }
                
                for score in toDelete {
                    modelContext.delete(score)
                }
                
                try? modelContext.save()
            }
            
            Button("Never Mind!") {}
        }
    }
    
    func positionOf(_ score: UCHiScoreEntry, within scores: [UCHiScoreEntry]) -> Int {
        let sortedScores = scores.sorted(using: SortDescriptor(\.score, order: .reverse))
        guard let index = sortedScores.firstIndex(where: {$0.id == score.id}) else {
            return -1
        }
        return index + 1
    }
}




#Preview {
    VStack {
        ScoreboardView(scores: scores, currentGameScore: current)
            .modelContext(ModelContext(previewModelContainer))
    }
    .padding()
    .fontDesign(.monospaced)
}

fileprivate var previewModelContainer: ModelContainer = {
    let schema = Schema([
        UCCategory.self,
        UCHiScoreEntry.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
fileprivate let current = UCHiScoreEntry(categoryID: UUID(), score: 236, rounds: 3, secondsPerRound: 10, numberOfOptions: 3)
fileprivate let scores = [
    UCHiScoreEntry(categoryID: UUID(), score: 235, rounds: 3, secondsPerRound: 10, numberOfOptions: 3),
    UCHiScoreEntry(categoryID: UUID(), score: 335, rounds: 3, secondsPerRound: 10, numberOfOptions: 3),
    UCHiScoreEntry(categoryID: UUID(), score: 201, rounds: 3, secondsPerRound: 10, numberOfOptions: 3),
    current,
    UCHiScoreEntry(categoryID: UUID(), score: 108, rounds: 3, secondsPerRound: 10, numberOfOptions: 3)
]
