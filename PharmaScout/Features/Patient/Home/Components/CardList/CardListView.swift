//
//  CardListView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct CardListView: View {
    var body: some View {
        VStack {
            SectionHeaderView(title: "Nearby pharmacies") {
                
            }
            
            list
        }
    }
    
    private var list: some View {
        VStack(spacing: Spacing.large) {
            ForEach(0...2, id: \.self) { i in
                CardListItemView(name: "Al-Shifa Pharmacy", rate: 4.7, distance: "10 km", responseRate: 92, isOpen: i % 2 == 0)
            }
        }
    }
    
    
}

#Preview {
    CustomNavStack {
        CardListView()
            .padding()
            .customNavBarVisibility(false)
    }
}
