//
//  PhotoCredits.swift
//  Undercover
//
//  Created by Mack Slevin on 4/27/24.
//

import SwiftUI

struct PhotoCredits: View {
    let photographers: [Photographer] = Photographer.creditedPhotographers
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("All of the photographs in this application were sourced from Unsplash.com. I would like to thank the following photographers for the use of their work. ")
                }
                .listSectionSeparator(.hidden)
                
                Section {
                    ForEach(photographers.sorted(by: {$0.displayName.lowercased() < $1.displayName.lowercased()})) { photographer in
                        Button {
                            UIApplication.shared.open(photographer.unsplashURL)
                        } label: {
                            HStack(spacing: 12) {
                                AsyncImage(url: photographer.imageURLs.first) { image in
                                    image.resizable().scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                        .shadow(radius: 1, x: 1, y: 1)
                                } placeholder: {
                                    ProgressView()
                                }

                                Text(photographer.displayName)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            .padding()
                            .background {
                                Capsule()
                                    .foregroundStyle(.quaternary)
                                    .padding(1)
                                    .background {
                                        Capsule().stroke()
                                    }
                            }
                        }
                        .listRowSeparator(.hidden)
                        
                    }
                }
                .listSectionSeparator(.hidden)
            }
            .navigationTitle("Photographers")
            .listStyle(.plain)
        }
    }
}

#Preview {
    PhotoCredits()
        .fontDesign(.monospaced)
        .onAppear {
            let fontRegular = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 20)
            let fontLarge = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 36)
            UINavigationBar.appearance().titleTextAttributes = [.font: fontRegular!]
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: fontLarge!]
        }
}


struct Photographer: Identifiable {
    let id = UUID()
    let displayName: String
    var imageURLs: [URL]
    var unsplashURL: URL
    
    static let creditedPhotographers: [Photographer] = [
        Photographer(displayName: "Wil Stewart", imageURLs: [URL(string:"https://images.unsplash.com/photo-1436076863939-06870fe779c2?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string:"https://unsplash.com/@wilstewart3")!),
        Photographer(displayName: "mostafa mahmoudi", imageURLs: [URL(string:"https://images.unsplash.com/photo-1609775436218-78e51e5e61dd?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@mostafa_mahmoudi24")!),
        Photographer(displayName: "Magnet.me", imageURLs: [URL(string:"https://images.unsplash.com/photo-1598257006626-48b0c252070d?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string:"https://unsplash.com/@magnetme")!),
        Photographer(displayName: "Evgeniy Alyoshin", imageURLs: [URL(string:"https://images.unsplash.com/photo-1699030287414-82ebb3dde5b0?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@oqtave")!),
        Photographer(displayName: "Francisco De Legarreta C.", imageURLs: [URL(string: "https://images.unsplash.com/photo-1675266873434-5ba73c38ce6f?q=80&w=2614&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@francisco_legarreta")!),
        Photographer(displayName: "charlesdeluvio", imageURLs: [URL(string: "https://images.unsplash.com/photo-1573761691575-2c10f2554119?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@charlesdeluvio")!),
        Photographer(displayName: "Ethan Sykes", imageURLs: [URL(string: "https://images.unsplash.com/photo-1486002113024-43b2ce358eb0?q=80&w=2392&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string:"https://unsplash.com/@e_sykes")!),
        Photographer(displayName: "Jason Hogan", imageURLs: [URL(string: "https://images.unsplash.com/photo-1543357480-c60d40007a3f?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@jasonhogan")!),
        Photographer(displayName: "krakenimages", imageURLs: [URL(string: "https://images.unsplash.com/photo-1600880292203-757bb62b4baf?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@krakenimages")!),
        Photographer(displayName: "Giorgio Trovato", imageURLs: [URL(string: "https://images.unsplash.com/photo-1578269174936-2709b6aeb913?q=80&w=2342&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@giorgiotrovato")!),
        Photographer(displayName: "Clay Banks", imageURLs: [URL(string: "https://images.unsplash.com/photo-1545315003-c5ad6226c272?q=80&w=2400&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@claybanks")!),
        Photographer(displayName: "Jeffery Erhunse", imageURLs: [URL(string: "https://images.unsplash.com/photo-1589156280159-27698a70f29e?q=80&w=2486&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!], unsplashURL: URL(string: "https://unsplash.com/@j_erhunse")!)
    ]
}
