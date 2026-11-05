//
//  CheckIconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/7/26.
//

import SwiftUI

struct CheckIconView: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 30))
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(20)
            .background {
                Circle()
                    .fill(.theme.secondaryStrong)
            }
            .padding(15)
            .background {
                Circle()
                    .fill(.theme.disabledBackground)
            }
    }
}

#Preview {
    CheckIconView()
}
