//
//  FuzzyImage.swift
//  Undercover
//
//  Created by Mack Slevin on 4/2/24.
//

import SwiftUI

struct FuzzyImage: View {
    let uiImage: UIImage
    
    @Environment(SinglePlayerGameController.self) var gameController
    @AppStorage("secondsPerRound") var secondsPerRound: Int = 30
    @AppStorage("shouldUseDesaturation") var shouldUseDesaturation = false
    
    
    @State private var blurAmount: Double = 50.0
    
    var body: some View {
        
        Image(uiImage: uiImage)
            .resizable().scaledToFit()
            .grayscale(shouldUseDesaturation ? 1 : 0)
            .blur(radius: blurAmount, opaque: true)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
            .onChange(of: gameController.currentRoundSecondsRemaining) { _, newValue in
                if let newValue {
                    let percentageThrough = (Double(newValue) / Double(secondsPerRound)) // What percantage of the time allotted has been used so far. From 0.0 to 1.0
                    
                    withAnimation(.linear(duration: 1)) {
                        blurAmount = blurAmount * percentageThrough
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
