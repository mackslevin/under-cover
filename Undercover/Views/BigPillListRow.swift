//
//  BigPillListRow.swift
//  Undercover
//
//  Created by Mack Slevin on 3/28/24.
//

import SwiftUI


struct BigPillListRow: View {
    
    let category: UCCategory
    @Binding var selectedCategoryID: UUID?
    
    
    var body: some View {
        Text(category.name)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowSeparator(.hidden)
            .padding()
            .background {
                ZStack {
                    Capsule()
                        .stroke()
                    Capsule()
                        .padding(1)
                        .foregroundStyle(selectedCategoryID == category.id ? Color.accentColor : Color.clear)
                }
            }
            .font(.title3)
            .multilineTextAlignment(.center)
            .listRowBackground(selectedCategoryID == category.id ? Color.clear : Color.clear)
            .tint(selectedCategoryID == category.id ? Color.clear : Color.clear)
            .contentShape(Capsule())
            .sensoryFeedback(.selection, trigger: selectedCategoryID == category.id)

    }
    
}

#Preview {
    NavigationStack {
        List {
            BigPillListRow(category: UCCategory(name: "This is Something"), selectedCategoryID: .constant(UUID()))
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
