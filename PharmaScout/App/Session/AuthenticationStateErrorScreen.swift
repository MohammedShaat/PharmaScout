//
//  AuthenticationStateErrorScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct AuthenticationStateErrorScreen: View {
    var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Text("Authentication failed")
                .font(.largeTitle)
            
            if let errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    AuthenticationStateErrorScreen(errorMessage: AppAuthError.sessionMissing.errorDescription)
}
