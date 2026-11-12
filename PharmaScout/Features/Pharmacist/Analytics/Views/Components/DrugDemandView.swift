//
//  DrugDemandView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/15/26.
//

import SwiftUI

struct DrugDemandView: View {
    let drugDemand: DrugDemand
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text(drugDemand.genericName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(drugDemand.drugFormulation.strength)
                    .font(.callout)
                    .foregroundStyle(.theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xxSmall) {
                Text("\(drugDemand.patientCount)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.theme.textPrimary)
                
                Text("Patient\(drugDemand.patientCount > 1 ? "s" : "")")
                    .font(.subheadline)
                    .foregroundStyle(.theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
}

#Preview {
    DrugDemandView(drugDemand: .samples[0])
}
