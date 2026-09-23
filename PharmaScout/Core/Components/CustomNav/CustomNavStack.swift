//
//  CustomNavStack.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomNavStack<Content: View>: View {
    private let content: Content
    private let path: Binding<NavigationPath>?
    @State private var deafultPath = NavigationPath()
    
    init(path: Binding<NavigationPath>, @ViewBuilder contet: () -> Content) {
        self.path = path
        self.content = contet()
    }
    
    init(@ViewBuilder contet: () -> Content) {
        self.path = nil
        self.content = contet()
    }
    
    var body: some View {
        NavigationStack(path: path ?? $deafultPath) {
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
