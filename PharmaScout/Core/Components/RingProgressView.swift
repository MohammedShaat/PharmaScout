//
//  RingProgressView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//

import SwiftUI

struct RingProgressView: View {
    var size: CGFloat = 18
    var isActive: Bool = true
    
    @State private var animate: Bool = false
    private let strokeWidth: Double = 3
    
    var body: some View {
        Circle()
            .stroke(lineWidth: strokeWidth)
            .fill(.theme.textTertiary)
            .overlay {
                Circle()
                    .trim(to: 0.3)
                    .stroke(lineWidth: strokeWidth)
                    .fill(.theme.onPrimary)
                    .rotationEffect(.degrees(animate && isActive ? 360 : 0))
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true),
                        value: animate
                    )
            }
            .frame(maxWidth: size)
            .onAppear {
                animate.toggle()
            }
    }
}

#Preview {
    RingProgressView()
        .padding()
        .background(.theme.primary)
}
