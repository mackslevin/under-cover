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
    
    let onRoundEnd: () -> Void
    
    @State private var timeRemaining = 30
    @State private var shuffledAlbums: [UCAlbum] = []
    @State private var isLoading = false
    @State private var albumCover: UIImage? = nil
    
    @State private var timer: AnyCancellable? = nil
    @State private var blurAmount: CGFloat = 15
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    
                    
                    VStack(spacing: 20) {
                        Text("Name the album...")
                            .font(.largeTitle).fontWeight(.black)
                            .opacity(0.5)
                        
                        if let albumCover {
                            ZStack {
                                Image(uiImage: albumCover)
                                    .resizable().scaledToFit()
                                    .blur(radius: blurAmount)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .frame(maxWidth: 500, maxHeight: 500)
                            .padding()
                            
                        }
                        
                        Text("Time remaining: \(timeRemaining)s")
                        
                        ForEach(shuffledAlbums) { album in
                            Button(album.albumTitle) {
                                timer?.cancel()
                                endRound(withGuess: album)
                            }
                            .bold()
                            .font(.title3)
                        }
                    }
                }
                
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
        gameController.handleRoundEnd(withGuess: guess)
        onRoundEnd()
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    withAnimation {
                        blurAmount -= 0.5
                    }
                } else {
                    // Dismiss the view
                    timer?.cancel()
                    endRound(withGuess: nil)
                }
            }
    }
    
    
}

//#Preview {
//    SPGuessingView(onRoundEnd: {})
//}
