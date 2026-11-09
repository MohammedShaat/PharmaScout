//
//  DividerView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/8/26.
//

import SwiftUI

struct DividerView: View {
    var color: Color = .theme.disabledBackground
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
    }
}

#Preview {
    DividerView()
}
