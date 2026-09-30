//
//  CustomNavView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomNavView<Content: View>: View {
    let content: Content
    
    @State private var title: String = ""
    @State private var showNavBar: Bool = true
    
    init(@ViewBuilder contet: () -> Content) {
        self.content = contet()
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            VStack {
                if showNavBar {
                    CustomeNavBarView(title: title)
                }
                
                VStack {
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onPreferenceChange(CustomNavStackNavBarVisibilityPreferenceKey.self) { newValue in
            showNavBar = newValue
        }
        .onPreferenceChange(CustomNavStackTitle.self) { newValue in
            title = newValue
        }
    }
}

extension View {
    func customNavBarVisibility(_ visibility: Bool) -> some View {
        preference(key: CustomNavStackNavBarVisibilityPreferenceKey.self, value: visibility)
    }
    
    func customNavTitle(_ title: String) -> some View {
        preference(key: CustomNavStackTitle.self, value: title)
    }
}

#Preview {
    CustomNavView {
        Text("Home Screen")
        .customNavTitle("Inline Title")
//            .customNavBarVisibility(false)
    }
}
