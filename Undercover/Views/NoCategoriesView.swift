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
            Text("You can convert Apple Music playlists into categories. This works best on playlists with tracks from many different albums.")
        }, actions: {
            Button {
                withAnimation(.bouncy) {
                    isShowingAddCategory.toggle()
                }
            } label: {
                Text("Search Playlists")
            }
            .buttonStyle(.borderedProminent)
        })
    }
}

#Preview {
    VStack {
        NoCategoriesView(isShowingAddCategory: .constant(false))
    }
    .fontDesign(.monospaced)
}
