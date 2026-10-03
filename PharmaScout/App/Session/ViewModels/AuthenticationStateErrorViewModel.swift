//
//  AuthenticationStateErrorViewModel.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import Foundation

@Observable
class AuthenticationStateErrorViewModel {
    private(set) var authStateError: AppError?
    
    init(error: Error) {
        self.authStateError = ErrorHandler.handle(error)
        print(authStateError as Any)
    }
}
