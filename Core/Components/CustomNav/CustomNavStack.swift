//
//  CustomNavStack.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomNavStack<Content: View, H: Hashable>: View {
    private let content: Content
    private let path: Binding<[H]>?
    @State private var defaultPath = NavigationPath()
    
    init(path: Binding<[H]>, @ViewBuilder contet: () -> Content) {
        self.path = path
        self.content = contet()
    }
    
    init(@ViewBuilder contet: () -> Content) where H == String {
        self.path = nil
        self.content = contet()
    }
    
    var body: some View {
        if let path {
            NavigationStack(path: path) {
                CustomNavView {
                    content
                }
            }
        } else {
            NavigationStack(path: $defaultPath) {
                CustomNavView {
                    content
                }
            }
        }
    }
}

#Preview {
    CustomNavStack {
        Text("Hi")
    }
}
