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
            ScrollView {
                VStack(alignment: .leading) {
                    Text(category.name).bold()
                    
                    
                    if let albums = category.albums {
                        ForEach(albums) { album in
                            HStack {
                                AsyncImage(url: album.coverImageURL) { image in
                                    image.resizable().scaledToFill()
                                        .frame(width: 40, height: 40)
                                } placeholder: {
                                    ZStack {
                                        Rectangle().foregroundStyle(.gray.gradient)
                                        Image(systemName: "questionmark.square.dashed")
                                    }
                                    .frame(width: 40, height : 40)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                VStack(alignment: .leading, content: {
                                    Text(album.albumTitle).italic()
                                    Text(album.artistName).foregroundStyle(.secondary)
                                })
                            }
                        }
                    } else {
                        Text("No albums")
                    }
                }
                .padding()
                .navigationTitle(category.name)
                .onAppear {
                    category.albums!.forEach { album in
                        print("^^ url \(album.coverImageURL?.absoluteString ?? "none")")
                    }
                }
            }
            
        }
    }
}

//#Preview {
//    CategoryDetailView()
//}
