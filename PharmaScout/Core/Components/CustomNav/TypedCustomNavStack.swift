//
//  CustomNavStack.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct TypedCustomNavStack<H: Hashable, Content: View>: View {
    private let content: Content
    private let path: Binding<[H]>
    
    init(path: Binding<[H]>, @ViewBuilder contet: () -> Content) {
        self.path = path
        self.content = contet()
    }
    
    var body: some View {
        NavigationStack(path: path) {
            CustomNavView {
                content
            }
        }
    }
}

#Preview {
    @State @Previewable var path: [String] = []
    
    TypedCustomNavStack(path: $path) {
        Text("Hi")
    }
}
