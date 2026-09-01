//
//  CircularIconView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/1/26.
//

import SwiftUI

struct CircularIconView: View {
    let image: ImageResource
    var bgSize: CGFloat = 80
    var iconSize: CGFloat = 40
    var bgColor: Color = .theme.disabledBackground
    
    var body: some View {
        Circle()
            .fill(bgColor)
            .frame(width: bgSize)
            .overlay {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize)
            }
    }
}

#Preview {
    CircularIconView(image: .mail)
}
