//
//  FillHeightViewModifier.swift
//  PharmaScout
//
//  Created by Mohammed on 11/7/26.
//

import SwiftUI

struct CenteredScrollView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                content
                    .frame(minHeight: proxy.size.height)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    CenteredScrollView {
        VStack {
            Text("Hello World!")
        }
    }
}
