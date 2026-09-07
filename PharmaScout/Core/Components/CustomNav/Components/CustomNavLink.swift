//
//  CustomNavLink.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomNavLink<Content: View, Label: View>: View {
    @ViewBuilder let content: Content
    @ViewBuilder let label: Label
    
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
