//
//  FilterView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/9/26.
//

import SwiftUI

struct FilterView<T: Hashable & Identifiable, Content: View, Icon: View>: View {
    @Binding var selection: T
    let label: String
    let pickerTitle: String
    let options: [T]
    let icon: Icon
    let content: (T) -> Content
    
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
                icon
                
                Text("\(pickerTitle):")
                    .foregroundStyle(.theme.textSecondary)
                
                Text(label)
                    .foregroundStyle(.theme.textPrimary)
                    .fontWeight(.bold)
                
                Image(systemName: "chevron.down")
                    .fontWeight(.regular)
                    .font(.callout)
            }
            .foregroundStyle(.theme.textTertiary)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(showBorder: true, borderColor: .theme.primary)
        }
    }
}

#Preview {
    @State @Previewable var filter: SearchFilter = .all
    
    FilterView(selection: $filter, label: "Filter", pickerTitle: "Status", options: SearchFilter.allCases) { status in
        Text(status.title)
    }
}

extension FilterView {
    init(
        selection: Binding<T>,
        label: String,
        pickerTitle: String,
        options: [T],
        @ViewBuilder content: @escaping (T) -> Content
    ) where Icon == Image {
        self.init(
            selection: selection,
            label: label,
            pickerTitle: pickerTitle,
            options: options,
            icon: Image(systemName: "line.3.horizontal.decrease"),
            content: content,
        )
    }
    
    init(
        selection: Binding<T>,
        label: String,
        pickerTitle: String,
        options: [T],
        @ViewBuilder icon: @escaping () -> Icon,
        @ViewBuilder content: @escaping (T) -> Content
    ) where Icon == Image {
        self._selection = selection
        self.label = label
        self.pickerTitle = pickerTitle
        self.options = options
        self.icon = icon()
        self.content = content
    }
}
