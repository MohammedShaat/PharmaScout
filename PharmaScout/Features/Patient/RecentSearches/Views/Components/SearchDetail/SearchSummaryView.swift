//
//  SearchSummaryView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import SwiftUI

struct SearchSummaryView: View {
    let search: Search
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            SearchStatusView(status: search.status)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Progress
            VStack {
                Text("\(search.fulfilledDrugsCount) of \(search.drugsCount) drugs fulfilled")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ProgressView(
                    value: Double(search.fulfilledDrugsCount),
                    total: Double(search.drugsCount),
                    color: search.status.color,
                    height: 8
                )
            }
            
            DividerView()
            
            // Fulfillment mode, substitute, radius, date
            VStack(spacing: DesignSystem.Spacing.large) {
                // Fulfillment mode & substitute
                HStack {
                    Label(
                        search.fulfilmentMode.title,
                        image: search.fulfilmentMode == .singlePharmacy ? .housePlus : .housePlusTwins
                    )
                    Spacer()
                    Label(
                        "Substitutes \(search.acceptSubstitute ? "Accepted" : "Rejected")",
                        systemImage: "arrow.left.arrow.right"
                    )
                }
                // Radius & date
                HStack {
                    Label("\(search.radiusMeters.formattedDistance) radius", systemImage: "circle.circle")
                    Spacer()
                    Label(
                        search.createdAt.formatted(date: .abbreviated, time: .omitted),
                        systemImage: "calendar"
                    )
                }
            }
            .font(.subheadline)
            .foregroundStyle(.theme.textSecondary)
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
        }
        .padding(DesignSystem.Spacing.large)
        .roundedBackground(showBorder: true, borderColor: search.status.color)
    }
}

#Preview {
    CustomNavStack {
        SearchSummaryView(search: .samples[0])
            .padding()
    }
}
