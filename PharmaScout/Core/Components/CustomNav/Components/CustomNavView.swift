//
//  CustomNavView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomNavView<Content: View>: View {
    let content: Content
    
    @State private var title: String?
    @State private var navBarStyle: NavBarStyle = .standard
    @State private var showBackButton: Bool = true
    
    init(@ViewBuilder contet: () -> Content) {
        self.content = contet()
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                if navBarStyle != .hidden {
                    CustomeNavBarView(title: title, showBackButton: showBackButton, style: navBarStyle)
                }
                
                VStack {
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onPreferenceChange(CustomNavStackNavBarVisibilityPreferenceKey.self) { newValue in
            navBarStyle = newValue
        }
        .onPreferenceChange(CustomNavStackBackButtonVisibilityPreferenceKey.self) { newValue in
            showBackButton = newValue
        }
        .onPreferenceChange(CustomNavStackTitle.self) { newValue in
            title = newValue
        }
    }
}

extension View {
    func customNavBarVisibility(_ visibility: NavBarStyle) -> some View {
        preference(key: CustomNavStackNavBarVisibilityPreferenceKey.self, value: visibility)
    }
    
    func customBackButtonVisibility(_ visibility: Bool) -> some View {
        preference(key: CustomNavStackBackButtonVisibilityPreferenceKey.self, value: visibility)
    }
    
    func customNavTitle(_ title: String) -> some View {
        preference(key: CustomNavStackTitle.self, value: title)
    }
}

enum NavBarStyle {
    case root
    case standard
    case hidden
}

#Preview {
    CustomNavView {
        Text("Home Screen")
        .customNavTitle("Inline Title")
//            .customNavBarVisibility(.root)
    }
}
