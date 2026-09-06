//
//  AlertFromOptional.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//

import SwiftUI

struct ErrorAlert: ViewModifier {
    let title: String
    @Binding var presenting: AppError?
    
    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: .init(optional: $presenting),
                presenting: presenting
            ) { _ in
                
            } message: { error in
                Text(error.errorDescription)
            }

    }
}

extension View {
    func errorAlert(title: String, error: Binding<AppError?>) -> some View {
        modifier(ErrorAlert(title: title, presenting: error))
    }
}

