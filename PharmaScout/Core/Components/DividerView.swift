//
//  DividerView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/8/26.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Rectangle()
            .fill(.theme.disabledBackground)
            .frame(height: 1)
    }
}

#Preview {
    DividerView()
}
