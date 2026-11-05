//
//  ActiveSearchesView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/28/26.
//

import SwiftUI

struct ActiveSearchesView: View {
    let activeSearches: [Search]
    let loadingState: LoadingState
    var onItemTapped: ((Search) -> Void)? = nil
    
    var body: some View {
        LoadingContentView(
            LoadingState: loadingState,
            showMessage: activeSearches.isEmpty,
            emptyTitle: "No active searches",
            emptyMessage: "You don't have any active searches at the moment. Start a new search to find nearby pharmacies.",
            showIcon: false
        ) {
            VStack {
                label
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    ForEach(activeSearches) { search in
                        activeSearchItem(search)
                            .clickable {
                                onItemTapped?(search)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
        }
    }
    
    private var label: some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            Image(systemName: "circle.fill")
                .font(.caption2)
            
            Text("Searching nearby pharamcies")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            Text("\(activeSearches.count) Active")
                .font(.footnote)
                .foregroundStyle(.theme.textSecondary)
        }
        .foregroundStyle(.theme.green)
    }
    
    private func activeSearchItem(_ search: Search) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Text(search.drugs.map(\.genericName), format: .list(type: .and))
                .fontWeight(.bold)
                .lineLimit(1)
                .disclosureIndicator()
            
            VStack(spacing: DesignSystem.Spacing.small) {
                ProgressView(
                    value: Double(search.fulfilledDrugsCount),
                    total: Double(search.drugsCount),
                    color: search.status.color,
                )
                
                HStack(spacing: 0) {
                    Text("\(search.fulfilledDrugsCount) of \(search.drugsCount) fulfilled")
                        .foregroundStyle(search.fulfilledDrugsCount == 0 ? .theme.textSecondary : .theme.textPrimary)
                    Spacer()
                    SearchStatusView(status: search.status)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(DesignSystem.Spacing.large)
        .roundedBackground()
    }
}

#Preview {
    ZStack {
        Color.theme.background.ignoresSafeArea()
        
        ActiveSearchesView(
            activeSearches: Search.samples.filter { $0.status == .pending },
            loadingState: LoadingState()
        )
    }
}
