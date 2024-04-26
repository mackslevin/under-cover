//
//  WelcomeView.swift
//  Undercover
//
//  Created by Mack Slevin on 4/25/24.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage(StorageKeys.isFirstRun.rawValue) var isFirstRun = true
    @Environment(\.dismiss) var dismiss
    
    var shadowColor = Color.gray
    var cornerRadius: CGFloat = 5
    
    var body: some View {
        TabView {
            // MARK: Screen 1
            VStack(alignment: .leading) {
                Spacer()
                Text("Under Cover")
                .fontDesign(.none)
                .font(.custom(Font.customFontName, size: 60))
                .kerning(-2)
                Text("is a quick time-killing game where you guess album covers.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 80)
            
            // MARK: Screen 2
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 20) {
                    HStack {
                        Image("prehistoric-burbank").resizable().scaledToFit()
                            .blur(radius: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Image(systemName: "arrow.right")
                        Image("prehistoric-burbank").resizable().scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    
                    VStack {
                        Button("Something"){}
                            .buttonStyle(PillButtonStyle())
                        Button("Another"){}
                            .buttonStyle(PillButtonStyle())
                        Button{} label: {
                            VStack {
                                Text("Prehistoric Burbank")
                                Text("by Olive Triangle")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .background {
                            ZStack {
                                Capsule().stroke()
                                Capsule().padding(1)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .tint(.primary)
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.quaternary)
                }
                .allowsHitTesting(false)
                Spacer()
                Text("You're shown an album cover which gradually reveals itself and a multiple choice list.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 80)
            
            // MARK: Screen 3
            VStack(alignment:.leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .aspectRatio(1, contentMode: .fit)
                    Image("clock")
                        .resizable().scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(1)
                }
                Spacer()
                Text("The sooner you guess the album cover, the more points you get.")
                    .padding(.bottom)
                Text("Bad guess or out of time? No points for you.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 80)
            
            // MARK: Screen 4
            VStack(alignment: .leading) {
                Image("search-screenshot")
                    .resizable().scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(1)
                    .background {
                        RoundedRectangle(cornerRadius: 5).stroke()
                    }
                
                Spacer()
                Text("Create a collection of albums to guess from by searching for public playlists on Apple Music. The app goes over the playlist's tracks and saves the albums they come from into a category you can replay as much as you like.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 80)
            
            // MARK: Screen 5
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .aspectRatio(1, contentMode: .fit)
                    Image("cheers")
                        .resizable().scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(1)
                }
                Spacer()
                Text("I think that's about it.")
                    .fontDesign(.none)
                    .font(.custom(Font.customFontName, size: 60))
                    .lineSpacing(0)
                    .kerning(-2)
                Button("Okay, cool") {
                    isFirstRun = false
                    dismiss()
                }
                .buttonStyle(PillButtonStyle())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 80)
        }
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 750 : .infinity)
        .fontDesign(.monospaced)
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
