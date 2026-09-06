//
//  CustomeHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct CustomeNavBarView: View {
    var title: String? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .padding(.horizontal, Spacing.xLarge)
                    .font(.title2)
                    .foregroundStyle(.theme.textPrimary)
                    .background(.red.opacity(0.001))
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            if let title{
                Text(title)
                    .padding()
            }
            
            Spacer()
            
            Image(systemName: "chevron.left")
                .padding(.horizontal, Spacing.xLarge)
                .font(.title2)
                .background(.red.opacity(0.001))
                .opacity(0)
        }
    }
}

#Preview {
    VStack {
        CustomeNavBarView()
        
        Spacer()
    }
}
