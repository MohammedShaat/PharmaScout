//
//  RadioView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import SwiftUI

struct RadioView: View {
    let title: String
    let isSelected: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Group {
                if isSelected {
                    Image(systemName: "0.circle.fill.hi")
                } else {
                    Image(systemName: "0.circle.hi")
                }
            }
            .foregroundStyle(.theme.secondary)
            
            Text(title)
        }
        .clickable(action: action)
    }
}

#Preview {
    HStack(spacing: 50) {
        RadioView(title: "Option 1", isSelected: true)
        
        RadioView(title: "Option 2", isSelected: false)
    }
}
