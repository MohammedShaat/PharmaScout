//
//  CustomNavLink.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomNavLink<Content: View, Label: View>: View {
    let content: Content
    let label: Label
    
    init(@ViewBuilder contet: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = contet()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            CustomNavView {
                content
                    .toolbarVisibility(.hidden, for: .navigationBar)
            }
        } label: {
            label
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CustomNavLink {
            Text("Second Screen")
        } label: {
            Text("Navigate")
        }
    }
}
