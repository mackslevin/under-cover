//
//  SPGuessingView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/26/24.
//

import SwiftUI
import Combine

struct SPGuessingView: View {
    @Environment(SinglePlayerGameController.self) var gameController
    @AppStorage(StorageKeys.secondsPerRound.rawValue) var secondsPerRound: Int = Utility.defaultSecondsPerRound
    @AppStorage(StorageKeys.guessLabelDisplayMode.rawValue) var guessMode: GuessLabelDisplayMode = .both
    @AppStorage(StorageKeys.shouldUseMusic.rawValue) var shouldUseMusic = true
    
    let onRoundEnd: () -> Void
    
    @State private var shuffledAlbums: [UCAlbum] = []
    @State private var isLoading = false
    @State private var albumCover: UIImage? = nil
    @State private var timer: AnyCancellable? = nil
    @State private var timeBarSeconds: Int = 100
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
//                ScrollView {
                    VStack(spacing: 20) {
                        if let albumCover {
                            FuzzyImage(uiImage: albumCover)
                                .frame(minHeight: 250)
                                .frame(maxWidth: 500, maxHeight: 500)
                                .layoutPriority(3)
                        }
                        
                        HStack(alignment: .center) {
                            Text("\(gameController.currentRoundSecondsRemaining ?? 0)s") 
                                .bold()
                                .foregroundStyle(.primary).colorInvert()
                                .font(.caption).bold()
                                .padding(4)
                                .background{
                                    Capsule()
                                        .foregroundStyle(.primary)
                                        .foregroundStyle(Double(gameController.currentRoundSecondsRemaining ?? 0) < (Double(secondsPerRound) * 0.25) ? Color.red : Color.primary)
                                }
                            
                            GeometryReader(content: { geometry in
                                Capsule()
                                    .frame(
                                        width: (geometry.size.width / CGFloat(secondsPerRound)) * CGFloat(timeBarSeconds),
                                        height: geometry.size.height
                                    )
                                    .foregroundStyle(Double(gameController.currentRoundSecondsRemaining ?? 0) < (Double(secondsPerRound) * 0.25) ? Color.red : Color.primary)
                            })
                        }
                        .font(.title3)
                        .frame(height: 30)
                        
                        ForEach(shuffledAlbums) { album in
                            Button {
                                endRound(withGuess: album)
                                timer?.cancel()
                            } label: {
                                VStack() {
                                    if guessMode == .titleOnly || guessMode == .both {
                                        Text(album.albumTitle.uppercased())
                                            .fontWeight(.bold)
                                            .minimumScaleFactor(0.7)
                                    }
                                    
                                    if guessMode == .artistOnly || guessMode == .both {
                                        Text("by \(album.artistName)")
                                            .font(.body)
                                            .minimumScaleFactor(0.7)
                                    }
                                }
                            }
                            .buttonStyle(PillButtonStyle())
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        Spacer()
                    }
                    .padding([.horizontal, .bottom])
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Text("\(gameController.currentRound)/\(gameController.rounds)")
                                .fontWeight(.black)
                        }
                    }
//                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isLoading = true
            
            gameController.currentRoundSecondsRemaining = secondsPerRound
            
            gameController.generateRound()
            
            if let current = gameController.currentAnswer {
                shuffledAlbums.append(current)
            }
            for decoy in gameController.currentDecoys {
                shuffledAlbums.append(decoy)
            }
            shuffledAlbums.shuffle()
            
            Task {
                if gameController.currentRound <= gameController.rounds && shouldUseMusic {
                    do {
                        try await gameController.playSongFromCurrentAnswer()
                    } catch {
                        print("^^ error playing song \(error)")
                    }
                }
                
                if let url = gameController.currentAnswer?.coverImageURL {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let uiImage = UIImage(data: data)
                    albumCover = uiImage
                }
            }
            
            
        }
        .onChange(of: albumCover) { oldValue, newValue in
            if oldValue == nil && newValue != nil {
                isLoading = false
                startTimer()
            }
        }
        .onChange(of: gameController.currentRoundSecondsRemaining) { _, newValue in
            withAnimation(.linear(duration: 1)) {
                if let newValue {
                    timeBarSeconds = newValue
                }
            }
            
            
        }
    }
    
    func endRound(withGuess guess: UCAlbum?) {
        gameController.handleRoundEnd(withGuess: guess, secondsRemaining: gameController.currentRoundSecondsRemaining ?? 0)
        onRoundEnd()
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if gameController.currentRoundSecondsRemaining ?? 0 > 0 {
                    gameController.currentRoundSecondsRemaining = (gameController.currentRoundSecondsRemaining ?? 0) - 1
                } else {
                    // Dismiss the view
                    endRound(withGuess: nil)
                    timer?.cancel()
                }
            }
    }
}



//#Preview {
//    SPGuessingView(onRoundEnd: {})
//        .environment(SinglePlayerGameController())
//        .fontDesign(.monospaced)
//}
