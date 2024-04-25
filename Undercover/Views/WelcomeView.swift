//
//  WelcomeView.swift
//  Undercover
//
//  Created by Mack Slevin on 4/25/24.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage(StorageKeys.isFirstRun.rawValue) var isFirstRun = true
    
    var body: some View {
        TabView {
            VStack {
                Text("Undercover is a simple time-killing game where you guess album covers.")
            }
            
            VStack {
                Text("There")
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onDisappear {
            isFirstRun = false
        }
    }
}

#Preview {
    WelcomeView()
        .fontDesign(.monospaced)
}
