//
//  CategoryDetailView.swift
//  Undercover
//
//  Created by Mack Slevin on 3/22/24.
//

import SwiftUI

struct CategoryDetailView: View {
    @Bindable var category: UCCategory
    var body: some View {
        NavigationStack {
            
            
            
            List(category.albums!) { album in
                HStack {
                    AsyncImage(url: album.coverImageURL) { image in
                        image.resizable().scaledToFill()
                            .frame(width: 40, height: 40)
                    } placeholder: {
                        Color.gray
                            .frame(width: 40, height: 40)
                    }
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, content: {
                        Text(album.albumTitle).italic()
                        Text(album.artistName).foregroundStyle(.secondary)
                    })
                }
            }
            .listStyle(.plain)
            .padding()
            .navigationTitle(category.name)
            
            
            
        }
    }
}

//#Preview {
//    CategoryDetailView()
//}
