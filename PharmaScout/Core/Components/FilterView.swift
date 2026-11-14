//
//  FilterView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/9/26.
//

import SwiftUI

struct FilterView<T: Hashable & Identifiable, Content: View>: View {
    @Binding var selection: T
    let title: String
    let pickerTitle: String
    let options: [T]
    @ViewBuilder let content: (T) -> Content
    
    var body: some View {
        Menu {
            Picker(pickerTitle, selection: $selection) {
                ForEach(options) { option in
                    content(option)
                        .tag(option)
                }
            }
        } label: {
            HStack {
                Image(systemName: "line.3.horizontal.decrease")
                
                Text("Filter:")
                    .foregroundStyle(.theme.textSecondary)
                
                Text(title)
                    .foregroundStyle(.theme.textPrimary)
                    .fontWeight(.bold)
                
                Image(systemName: "chevron.down")
                    .fontWeight(.regular)
                    .font(.callout)
            }
            .foregroundStyle(.theme.textTertiary)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground()
        }
    }
}

#Preview {
    @State @Previewable var filter: SearchFilter = .all
    
    FilterView(selection: $filter, title: "Filter", pickerTitle: "Status", options: SearchFilter.allCases) { status in
        Text(status.title)
    }
}
