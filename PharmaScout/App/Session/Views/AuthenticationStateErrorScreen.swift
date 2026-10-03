//
//  AuthenticationStateErrorScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct AuthenticationStateErrorScreen: View {
    
    @State private var vm: AuthenticationStateErrorViewModel
    
    init(error: Error) {
        let viewModel = AuthenticationStateErrorViewModel(error: error)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text("Authentication failed")
                .font(.largeTitle)
            
            if let authStateError = vm.authStateError {
                Text(authStateError.errorDescription)
            }
        }
    }
}

#Preview {
    AuthenticationStateErrorScreen(error: URLError(.badURL))
}
