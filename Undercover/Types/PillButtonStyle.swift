//
//  GuessButtonStyle.swift
//  Undercover
//
//  Created by Mack Slevin on 3/29/24.
//

import SwiftUI

struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .background {
                ZStack {
                    Capsule().stroke()
                    Capsule().padding(1)
                        .foregroundStyle(configuration.isPressed ? Color.accentColor : Color.clear)
                }
            }
    }
}
