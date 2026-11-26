//
//  PreviewTheme.swift
//  PharmaScout
//
//  Created by Mohammed on 11/26/26.
//

import SwiftUI

struct PreviewTheme: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            content
        }
    }
}

extension View {
    func previewTheme() -> some View {
        modifier(PreviewTheme())
    }
}

#Preview {
    Text("Theme")
        .previewTheme()
}
