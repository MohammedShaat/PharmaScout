//
//  CustomStepperView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/13/26.
//

import SwiftUI

struct CustomStepperView: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        Stepper(value: $value, in: 1...100) {
            Text("^[\(value) unit](inflect: true)")
        }
        
//        HStack(spacing: DesignSystem.Spacing.xLarge) {
//            button(systemName: "minus")
//                .clickable(isDisabled: !range.contains(value - 1)) {
//                    value -= 1
//                }
//            
//            Text(value, format: .number)
//                .font(.title2)
//                .frame(minWidth: 40)
//            
//            button(systemName: "plus")
//                .clickable(isDisabled: !range.contains(value + 1)) {
//                    value += 1
//                }
//        }
    }
    
    private func button(systemName name: String) -> some View {
        Image(systemName: name)
            .frame(width: 15, height: 15)
            .padding(DesignSystem.Spacing.small)
            .background(.theme.primary)
            .foregroundStyle(.theme.onPrimary)
    }
}

#Preview {
    @State @Previewable var quantity = 5
    
    CustomStepperView(value: $quantity, range: 1...100)
        .padding()
}
