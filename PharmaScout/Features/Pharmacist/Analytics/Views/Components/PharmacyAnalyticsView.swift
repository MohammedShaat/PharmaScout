//
//  PharmacyAnalyticsView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/15/26.
//

import SwiftUI

struct PharmacyAnalyticsView: View {
    let pharmacySearchAnalytics: PharmacySearchAnalytics
    let loadingState: LoadingState
    let period: AnalyticsPeriod
    
    @State private var maxHeightOfAnsweredDrugs: Double = 0
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            totalDrugsRequested
            
            answeredDrugRequests
            
            drugDemandListSection
        }
    }
    
    private var totalDrugsRequested: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text("Drugs requested")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.theme.textTertiary)
            
            Text("\(pharmacySearchAnalytics.totalDrugsRequested)")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.theme.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
    
    private var answeredDrugRequests: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.large) {
            Group {
                requestStatisticCard(
                    label: "Drugs answered",
                    count: pharmacySearchAnalytics.totalDrugsAnswered,
                    total: pharmacySearchAnalytics.totalDrugsRequested,
                    of: "requested"
                )
                
                requestStatisticCard(
                    label: "Answered as available",
                    count: pharmacySearchAnalytics.totalDrugsAnsweredAvailable,
                    total: pharmacySearchAnalytics.totalDrugsRequested,
                    of: "answered"
                )
            }
            .readFrame {
                maxHeightOfAnsweredDrugs = max(maxHeightOfAnsweredDrugs, $0.size.height)
            }
            .frame(minHeight: maxHeightOfAnsweredDrugs, alignment: .top)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignSystem.Spacing.large)
            .roundedBackground()
        }
    }
    
    private func requestStatisticCard(label: String, count: Int, total: Int, of totalLable: String) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.theme.textTertiary)
                
                Text("\(count)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.blue)
            }
            
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                ProgressView(value: count, total: total, color: .theme.green)
                
                Text("\(percentage(count, of: total))% of \(totalLable)")
                    .font(.footnote)
                    .foregroundStyle(.theme.textSecondary)
            }
        }
    }
    
    private var drugDemandListSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
                Text("Most requested medicines")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.textPrimary)
                
                Text("Requested from your pharmacy · last \(period.title)")
                    .font(.subheadline)
                    .foregroundStyle(.theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LoadingContentView(
                loadingState: loadingState,
                showMessage: pharmacySearchAnalytics.drugDemands.isEmpty,
                emptyTitle: "No medicine requests to show",
                emptyMessage: "There are no requested medicines to show for the last \(period.title).",
                errorTitle: "Couldn't load medicine requests"
            ) {
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(pharmacySearchAnalytics.drugDemands) { drugDemand in
                        DrugDemandView(drugDemand: drugDemand)
                    }
                }
            }
        }
        .padding(.vertical, DesignSystem.Spacing.xLarge)
    }
}

#Preview {
    let analytics = PharmacySearchAnalytics(drugDemands: [.samples[0], .samples[1]], totalDrugsRequested: 50, totalDrugsAnswered: 40, totalDrugsAnsweredAvailable: 25)
    
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        PharmacyAnalyticsView(
            pharmacySearchAnalytics: analytics,
            loadingState: LoadingState(),
            period: .sevenDays
        )
            .padding()
    }
}
