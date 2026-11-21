//
//  EmptyIcon.swift
//  PharmaScout
//
//  Created by Mohammed on 11/21/26.
//

import SwiftUI

struct ErrorIconView: View {
    var body: some View {
        Image(.triangleExclamationMark)
            .resizable()
            .scaledToFit()
            .frame(width: 34)
            .foregroundStyle(.theme.error)
            .padding(18)
            .roundedBackground(showBorder: true)
            .padding(10)
            .overlay {
                Circle()
                    .stroke(
                        .theme.error.opacity(0.6),
                        style: .init(lineWidth: 1)
                    )
            }
            .padding(18)
            .background {
                Circle()
                    .fill(.theme.error.opacity(0.1))
            }
    }
}

#Preview {
    ErrorIconView()
}
