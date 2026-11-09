//
//  SearchView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/9/26.
//

import SwiftUI

struct SearchView: View {
    let search: Search
    
    private var mainColor: Color {
        switch search.status {
        case .fulfilled: .theme.green
        case .awaitingContinuation: .theme.goldenBrown
        case .unfulfilled: .theme.red
        case .pending: .theme.blue
        default: .theme.primary
        }
    }
    
    private var surfaceColor: Color {
        switch search.status {
        case .fulfilled: .theme.greenBackground
        case .awaitingContinuation: .theme.goldenBrownBackground
        case .unfulfilled: .theme.redBackground
        case .pending: .theme.blueBackground
        default: .theme.disabledBackground
        }
    }
    
    var body: some View {
        CustomNavValueLink(value: SearchDetailRoute(searchId: search.id, search: search)) {
            VStack(spacing: DesignSystem.Spacing.large) {
                statusSection
                
                drugListSection
                
                progressSection
                
                DividerView()
                
                additionalInfoSection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground(showBorder: true)
        }
    }
    
    private var statusSection: some View {
        HStack {
            HStack {
                switch search.status {
                case .fulfilled: Image(systemName: "checkmark.circle")
                case .awaitingContinuation: Image(systemName: "arrow.right.circle")
                case .partiallyFulfilled: Image(systemName: "circle.lefthalf.filled")
                case .unfulfilled: Image(systemName: "xmark.circle")
                case .pending: Image(systemName: "clock")
                }
                
                Text(search.status.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .foregroundStyle(mainColor)
            .padding(.horizontal, DesignSystem.Spacing.medium)
            .padding(.vertical, DesignSystem.Spacing.small)
            .roundedBackground(background: surfaceColor)
            
            Spacer()
            
            Image(systemName: "chevron.forward")
                .foregroundStyle(.theme.textSecondary)
        }
    }
    
    private var drugListSection: some View {
        VStack(alignment: .leading) {
            ForEach(search.drugs) { drug in
                VStack(spacing: 0) {
                    Text(drug.genericName)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(drug.strength)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .lineLimit(1)
            }
        }
        .foregroundStyle(.theme.textPrimary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var progressSection: some View {
        if search.status != .pending {
            VStack {
                Text("\(search.fulfilledDrugsCount) of \(search.drugsCount) drugs fulfilled")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ProgressView(
                    value: Double(search.fulfilledDrugsCount),
                    total: Double(search.drugsCount),
                    color: mainColor
                )
            }
        } else {
            Text("Waiting for replies")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        if search.status == .awaitingContinuation {
            Text("Your reply is needed to continue")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .foregroundStyle(mainColor)
                .padding(DesignSystem.Spacing.large)
                .roundedBackground(background: surfaceColor, radius: DesignSystem.CornerRadius.small)
        }
    }
    
    private var additionalInfoSection: some View {
        VStack(spacing: DesignSystem.Spacing.xSmall) {
            HStack(spacing: DesignSystem.Spacing.large) {
                Text(search.fulfilmentMode.title)
                
                Label(search.radiusMeters.formattedDistance, systemImage: "circle.circle")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(search.createdAt, format: .dateTime.day().month(.abbreviated).year(.twoDigits))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.footnote)
        .foregroundStyle(.theme.textSecondary)
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 30){
            SearchView(search: .samples[0])
            
            SearchView(search: .samples[3])
        }
        .padding()
    }
}
