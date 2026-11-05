//
//  ProgressView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/9/26.
//

import SwiftUI

struct ProgressView: View {
    let value: Double
    let total: Double
    var color: Color = .theme.primary
    var height: Double = 6
    
    private var percentage: Double { value / total }
    @State private var fullWidth: Double = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
            .fill(.theme.disabledBackground)
            .frame(height: height)
            .readFrame { fullWidth = $0.size.width}
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(color)
                    .frame(width: fullWidth * percentage)
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressView(value: 2, total: 3)
        
        ProgressView(value: 3, total: 3)
    }
        .padding(50)
}
