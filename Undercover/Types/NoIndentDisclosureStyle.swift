//
//  NoIndentDisclosureStyle.swift
//  Undercover
//
//  Created by Mack Slevin on 10/29/24.
//
import SwiftUI

struct NoIndentDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                configuration.isExpanded.toggle()
            } label: {
                HStack {
                    configuration.label
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(configuration.isExpanded ? 90 : 0))
                        .scaleEffect(0.8)
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                }
            }
            .buttonStyle(.plain)
            
            
            if configuration.isExpanded {
                configuration.content
                    .padding(.top, 8)
            }
        }
    }
}
