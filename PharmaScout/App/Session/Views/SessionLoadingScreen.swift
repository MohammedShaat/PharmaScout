//
//  SessionLoadingScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct SessionLoadingScreen: View {
    var body: some View {
        ZStack {
            Color.theme.primary.ignoresSafeArea()
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}

#Preview {
    SessionLoadingScreen()
}
