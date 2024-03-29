//
//  BigPillListRow.swift
//  Undercover
//
//  Created by Mack Slevin on 3/28/24.
//

import SwiftUI

struct BigPillListRow: View {
    let category: UCCategory
    
    @State private var isHighlighted = false
    
    var body: some View {
        Text(category.name)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowSeparator(.hidden)
            .padding()
            .background {
                Capsule().stroke()
            }
            .font(.title3)
            .multilineTextAlignment(.center)
            
    }
    
}

#Preview {
    NavigationStack {
        List {
            BigPillListRow(category: UCCategory(name: "This is Something"))
            BigPillListRow(category: UCCategory(name: "This is Something"))
            BigPillListRow(category: UCCategory(name: "This is Something"))
        }
        .navigationTitle("Categories")
        .onAppear {
            let fontRegular = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 20)
            let fontLarge = UIFont(name: "PPNikkeiMaru-Ultrabold", size: 36)
            UINavigationBar.appearance().titleTextAttributes = [.font: fontRegular!]
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: fontLarge!]
        }
        .fontDesign(.monospaced)
        .listStyle(.plain)
        
        
    }
    
    
}
