//
//  AlertFromOptional.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//

import SwiftUI

struct ErrorAlert: ViewModifier {
    let title: String
    @Binding var loadingState: LoadingState
    
    private var error: AppError? { loadingState.error }
    
    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: .init(optionalValue: error) { isPresented in
                    if !isPresented {
                        loadingState.clearError()
                    }
                },
                presenting: error
            ) { _ in
                
            } message: { error in
                Text(error.errorDescription)
            }
    }
}

extension View {
    func errorAlert(title: String, loadingState: Binding<LoadingState>) -> some View {
        modifier(ErrorAlert(title: title, loadingState: loadingState))
    }
}

