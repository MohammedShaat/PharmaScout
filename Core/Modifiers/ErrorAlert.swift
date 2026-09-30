//
//  AlertFromOptional.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//

import SwiftUI

struct ErrorAlert: ViewModifier {
    let title: String
    let error: AppError?
    
    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: .init(optionalValue: error),
                presenting: error
            ) { _ in
                
            } message: { error in
                Text(error.errorDescription)
            }
    }
}

extension View {
    func errorAlert(title: String, error: AppError?) -> some View {
        modifier(ErrorAlert(title: title, error: error))
    }
}

