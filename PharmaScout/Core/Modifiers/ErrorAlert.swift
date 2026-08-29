//
//  AlertFromOptional.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//

import SwiftUI

struct ErrorAlert<T: LocalizedError>: ViewModifier {
    let title: String
    @Binding var presenting: T?
    
    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: .init(optional: $presenting),
                presenting: presenting
            ) { _ in
                
            } message: { error in
                Text(error.errorDescription ?? "Something went wrong. Please try again later.")
            }

    }
}

extension View {
    func errorAlert<T: LocalizedError>(title: String, error: Binding<T?>) -> some View {
        modifier(ErrorAlert(title: title, presenting: error))
    }
}

