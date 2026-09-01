//
//  HomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/2/26.
//

import SwiftUI

struct HomeScreen: View {
    let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var body: some View {
        CustomNavStack {
            VStack {
                Text("Welcome to PharmaScout")
                    .font(.largeTitle)
                
                Button("Log out") {
                    Task {
                        try? await authService.signOut()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreen(authService: MockAuthService.sample)
}
