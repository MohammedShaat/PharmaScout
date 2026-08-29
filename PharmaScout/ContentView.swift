//
//  ContentView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SignUpScreen(authService: DefaultAuthService())
    }
}

#Preview {
    ContentView()
}
