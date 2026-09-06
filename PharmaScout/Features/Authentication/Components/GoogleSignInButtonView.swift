//
//  GoogleSignInButtonView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import SwiftUI
import GoogleSignInSwift

struct GoogleSignInButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(.googleG)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                
                Text("Continue with Google")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                    .stroke()
                    .fill(.theme.borderFocused)
            )
        }
        .buttonStyle(.plain)
    }
}	

#Preview {
    GoogleSignInButtonView {
        
    }
    .padding()
}
