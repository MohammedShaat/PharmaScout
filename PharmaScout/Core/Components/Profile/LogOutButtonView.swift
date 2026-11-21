//
//  LogOutButtonView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/25/26.
//

import SwiftUI

struct LogOutButtonView: View {
    let isLoading: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Text("Log out")
                
                if isLoading {
                    RingProgressView()
                }
            }
        }
        .disabled(isLoading)
    }
}

#Preview {
    VStack(spacing: 30) {
        LogOutButtonView(isLoading: false)
        
        LogOutButtonView(isLoading: true)
    }
}
