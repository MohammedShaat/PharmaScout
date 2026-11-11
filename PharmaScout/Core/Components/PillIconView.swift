//
//  PillIconView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/5/26.
//

import SwiftUI

struct PillIconView: View {
    var body: some View {
        Image(systemName: "pill")
            .padding(DesignSystem.Spacing.medium)
            .background(.theme.disabledBackground)
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
    }
}

#Preview {
    PillIconView()
}
