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
                
                
                
                    Image(uiImage: UIImage(data: try! Data(contentsOf: category.albums!.first!.coverImageURL!))!)
                        .resizable().scaledToFit()
                
                
                
                HStack {
//                    AsyncImage(url: album.coverImageURL) { image in
//                        image.resizable().scaledToFill()
//                            .frame(width: 40, height: 40)
//                    } placeholder: {
//                        ZStack {
//                            Rectangle().foregroundStyle(.gray.gradient)
//                            Image(systemName: "questionmark.square.dashed")
//                        }
//                        .frame(width: 40, height : 40)
//                    }
//                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    VStack(alignment: .leading, content: {
                        Text(album.albumTitle).italic()
                        Text(album.artistName).foregroundStyle(.secondary)
                    })
                }
            }
            .padding()
            .navigationTitle(category.name)
            
            
        }
    }
}

//#Preview {
//    CategoryDetailView()
//}
