//
//  StaticMapPreview.swift
//  PharmaScout
//
//  Created by Mohammed on 11/18/26.
//

import SwiftUI

struct StaticMapPreview: View {
    var body: some View {
        VStack {
            Image(.location)
                .frame(width: 22)
                .foregroundStyle(.theme.onPrimary)
                .padding(DesignSystem.Spacing.large)
                .background(.theme.primary)
                .clipShape(.circle)
        }
    }
}

#Preview {
    StaticMapPreview()
}
