//
//  CustomSegmentPickerView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/15/26.
//

import SwiftUI

struct CustomSegmentPickerView<T: Identifiable & Equatable, Content: View>: View {
    @Binding var selection: T?
    let options: [T]
    @ViewBuilder let optionView: (T) -> Content
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options) { option in
                optionView(option)
                    .font(.callout)
                    .fontWeight(selection == option ? .bold : .regular)
                    .foregroundStyle(selection == option ? .theme.textPrimary : .theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(DesignSystem.Spacing.small)
                    .background {
                        if selection == option {
                            Color.clear
                                .roundedBackground(
                                    background: selection == option ? .theme.surface : .clear,
                                    radius: DesignSystem.CornerRadius.small
                                )
                                .matchedGeometryEffect(id: "background", in: animation)
                        }
                    }
                    .clickable {
                        withAnimation(.spring(bounce: 0.5)) {
                            selection = option
                        }
                    }
                
            }
        }
        .padding(DesignSystem.Spacing.xSmall)
        .roundedBackground(background: .theme.disabledBackground, radius: DesignSystem.CornerRadius.small)
    }
}

#Preview {
    @State @Previewable var selection: InquiryResponse = .available
    
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        CustomSegmentPickerView(selection: $selection, options: InquiryResponse.allCases) {
            Text($0.title)
        }
    }
}

extension CustomSegmentPickerView {
    
    init(
        selection: Binding<T>,
        options: [T],
        @ViewBuilder optionView: @escaping (T) -> Content
    ) {
        self._selection = Binding(
            get: { selection.wrappedValue },
            set: { selection.wrappedValue = $0 ?? selection.wrappedValue}
        )
        self.options = options
        self.optionView = optionView
    }
}
