//
//  SheetHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/8/26.
//

import SwiftUI

struct SheetHeaderView: View {
    let title: String
    let onCancelTapped: () -> Void
    
    var body: some View {
        ZStack {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(.theme.textPrimary)
            
            Text("Cancel")
                .fontWeight(.medium)
                .foregroundStyle(.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clickable(action: onCancelTapped)
        }
    }
}

#Preview {
    SheetHeaderView(title: "Title") {
        
    }
}
