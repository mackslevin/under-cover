//
//  NoCategoriesView.swift
//  Undercover
//
//  Created by Mack Slevin on 4/9/24.
//

import SwiftUI

struct NoCategoriesView: View {
    @Binding var isShowingAddCategory: Bool
    
    var body: some View {
        ContentUnavailableView(label: {
            Label("No categories yet...", systemImage: "xmark.seal.fill")
        }, description: {
            Text("Find public playlists on Apple Music and convert them into categroies to play.")
        }, actions: {
            Button {
                isShowingAddCategory.toggle()
            } label: {
                Text("Search Playlists")
                    .bold()
            }
            .buttonStyle(.plain)
            .padding()
            .background {
                Capsule()
                    .foregroundStyle(.accent.gradient)
                    .shadow(radius: 1, x: 1, y: 2)
            }
        })
    }
}

#Preview {
    VStack {
        NoCategoriesView(isShowingAddCategory: .constant(false))
    }
    .fontDesign(.monospaced)
}
