//
//  PlaylistSearchResultsRow.swift
//  Undercover
//
//  Created by Mack Slevin on 4/9/24.
//

import SwiftUI
import MusicKit

struct PlaylistSearchResultsRow: View {
    let playlist: Playlist
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                AsyncImage(url: playlist.artwork?.url(width: 180, height: 180), content: { image in
                    image
                        .resizable().scaledToFill()
                        .frame(width: 90, height: 90)
                }, placeholder: {
                    Rectangle()
                        .frame(width: 90, height: 90)
                })
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
                    
                VStack(alignment: .leading) {
                    HStack {
                        Text(playlist.name)
                            .bold()
                        Spacer()
                        Text("\(playlist.entries?.count ?? 0) \(playlist.entries?.count ?? 0 == 1 ? "song" : "songs")")
                    }
                    .multilineTextAlignment(.leading)
                    
                    Text(playlist.curatorName ?? "")
                }
                .font(.caption)
                
                Spacer()
            }
        }
        .tint(.primary)
        
    }
}

//#Preview {
//    VStack {
//        PlaylistSearchResultsRow(){}
//    }
//    .padding()
//    .fontDesign(.monospaced)
//    
//}
