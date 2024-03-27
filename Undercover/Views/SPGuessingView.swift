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
    @AppStorage("secondsPerRound") var secondsPerRound: Int = 30
    @AppStorage("guessLabelDisplayMode") var guessMode: GuessLabelDisplayMode = .titleOnly
    
    let onRoundEnd: () -> Void
    
    @State private var timeRemaining = 30
    @State private var shuffledAlbums: [UCAlbum] = []
    @State private var isLoading = false
    @State private var albumCover: UIImage? = nil
    
    @State private var timer: AnyCancellable? = nil
    @State private var blurAmount: CGFloat = 15
    @State private var timerImageName: String = "circle.fill"
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        if let albumCover {
                            Image(uiImage: albumCover)
                                .resizable().scaledToFit()
                                .blur(radius: blurAmount)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .frame(maxWidth: 500, maxHeight: 500)
                                .shadow(radius: 12)
                                .padding()
                        }
                        
                        ForEach(shuffledAlbums) { album in
                            Button {
                                endRound(withGuess: album)
                                timer?.cancel()
                            } label: {
                                VStack() {
                                    if guessMode == .titleOnly || guessMode == .both {
                                        Text(album.albumTitle)
                                    }
                                    
                                    if guessMode == .artistOnly || guessMode == .both {
                                        Text("by \(album.artistName)")
                                            .font(.body)
                                    }
                                }
                                
                            }
                            .bold()
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        Spacer()
                    }
                    .padding([.horizontal, .bottom])
                    
                }
                
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: timerImageName)
                    .bold()
                    .foregroundStyle(Double(timeRemaining) < (Double(secondsPerRound) * 0.25) ? Color.red : Color.primary)
            }
        }
        .onAppear {
            isLoading = true
            timeRemaining = secondsPerRound
            gameController.generateRound()
            
            if let current = gameController.currentAnswer {
                shuffledAlbums.append(current)
            }
            for decoy in gameController.currentDecoys {
                shuffledAlbums.append(decoy)
            }
            shuffledAlbums.shuffle()
            
            Task {
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
    }
    
    func endRound(withGuess guess: UCAlbum?) {
        gameController.handleRoundEnd(withGuess: guess, secondsRemaining: timeRemaining)
        onRoundEnd()
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    withAnimation {
                        let newBlurAmount = CGFloat((CGFloat(timeRemaining) / CGFloat(secondsPerRound)) * 15)
                        blurAmount = newBlurAmount
                        timerImageName = "\(timeRemaining).circle.fill"
                    }
                } else {
                    // Dismiss the view
                    endRound(withGuess: nil)
                    timer?.cancel()
                }
            }
    }
}

#Preview {
    SPGuessingView(onRoundEnd: {})
        .environment(SinglePlayerGameController())
}
