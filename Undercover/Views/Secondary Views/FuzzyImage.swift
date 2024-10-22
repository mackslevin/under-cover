//
//  FuzzyImage.swift
//  Undercover
//
//  Created by Mack Slevin on 4/2/24.
//

import SwiftUI
import Combine

struct FuzzyImage: View {
    let uiImage: UIImage
    
    @Environment(SinglePlayerGameController.self) var gameController
    @AppStorage(StorageKeys.secondsPerRound.rawValue) var secondsPerRound: Int = 10
    @AppStorage(StorageKeys.shouldUseDesaturation.rawValue) var shouldUseDesaturation = false
    
    @State private var blurAmount = 50.0
    
    let maxBlur = 50.0
    
    var body: some View {
        
        Image(uiImage: uiImage)
            .resizable().scaledToFit()
            .blur(radius: blurAmount, opaque: true)
            .grayscale(shouldUseDesaturation ? 1 : 0)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
            .onAppear {
                Task { @MainActor in
                    // Define frequency of blur adjustment so that we reach 0 with 10% time remaining.
                    var frequency = Double(secondsPerRound)/100.00
                    frequency = frequency - (frequency * 0.1)
                    
                    while true {
                        try await Task.sleep(for: .seconds(frequency))
                        blurAmount = blurAmount - (maxBlur/100.0)
                    }
                }
            }
    }
}

#Preview {
    VStack {
        FuzzyImage(uiImage: UIImage(named: "armed-forces")!)
            .environment(SinglePlayerGameController())
        
        Spacer()
    }
    .padding()
    
}
