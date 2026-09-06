//
//  CustomNavStack.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomNavStack<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder contet: () -> Content) {
        self.content = contet()
    }
    
    var body: some View {
        NavigationStack {
            CustomNavView {
                content
            }
        }
    }
}

#Preview {
    CustomNavStack {
        Text("Hi")
    }
}
