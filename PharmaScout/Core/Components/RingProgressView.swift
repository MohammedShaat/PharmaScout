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
    var trimColor: Color = .theme.primary
    
    @State private var animate: Bool = false
    private let strokeWidth: Double = 3
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    .theme.disabledContent.opacity(0.5),
                    style: .init(lineWidth: strokeWidth)
                )
                .overlay {
                    Circle()
                        .trim(to: 0.3)
                        .stroke(
                            trimColor,
                            style: .init(lineWidth: strokeWidth)
                        )
                        .rotationEffect(.degrees(animate && isActive ? 360 : 0))
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true),
                            value: animate
                        )
                }
        }
        .frame(width: size, height: size)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            Text("Text")
            
            RingProgressView()
                .padding()
                .background(.theme.primary)
                .frame(maxWidth: .infinity)
        }
    }
}
