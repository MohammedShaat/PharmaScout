//
//  AnalyticsScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import SwiftUI

struct AnalyticsScreen: View {
    @State private var vm: AnalyticsViewModel
    @State private var analyticsTask: Task<Void, Never>?
    
    init(pharmacyId: String, analyticsService: AnalyticsService) {
        let viewModel = AnalyticsViewModel(
            pharmacyId: pharmacyId,
            analyticsService: analyticsService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            VStack(spacing: DesignSystem.Spacing.large) {
                analyticsTypeSection

                periodSegmentSection

                ScrollView {
                    VStack {
                        switch vm.analyticsType {
                        case .pharmacySearch:
                            pharmacyAnalyticsSection
                            
                        case .regional:
                            regionalAnalyticsSection
                        }
                    }
                }
                .refreshable(action: vm.refresh)
            }
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
            .customNavBarVisibility(.root)
            .customNavTitle("Analytics")
            .onAppear(perform: vm.loadAnalyticsIfNeeded)
            .onDisappear {
                analyticsTask?.cancel()
            }
            .onChange(of: vm.period) {
                analyticsTask?.cancel()
                analyticsTask = Task {
                    await vm.loadAnalytics()
                }
            }
            .onChange(of: vm.analyticsType) {
                analyticsTask?.cancel()
                analyticsTask = Task {
                    await vm.loadAnalytics()
                }
            }
        }
    }
    
    private var analyticsTypeSection: some View {
        FilterView(
            selection: $vm.analyticsType,
            label: vm.analyticsType.title,
            pickerTitle: "Type",
            options: AnalyticsType.allCases,
            icon: { Image(systemName: "chart.bar") }
        ) { type in
            Text(type.title)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var periodSegmentSection: some View {
        CustomSegmentPickerView(
            selection: $vm.period,
            options: AnalyticsPeriod.allCases) { period in
                Text(period.title)
            }
    }
    
    @ViewBuilder
    private var pharmacyAnalyticsSection: some View {
        LoadingContentView(
            LoadingState: vm.pharmacyAnalyticsLoadingState,
            showMessage: vm.pharmacySearchAnalytics == nil,
            emptyTitle: "No pharmacy search analytics",
            emptyMessage: "Requests sent to your pharmacy will be counted here. Try a longer period."
        ) {
            if let pharmacySearchAnalytics = vm.pharmacySearchAnalytics {
                PharmacyAnalyticsView(
                    pharmacySearchAnalytics: pharmacySearchAnalytics,
                    loadingState: vm.pharmacyAnalyticsLoadingState,
                    period: vm.period
                )
            }
        }
    }
    
    private var regionalAnalyticsSection: some View {
        LoadingContentView(
            LoadingState: vm.regionalAnalyticsLoadingState,
            showMessage: vm.regionalDrugDemands.isEmpty,
            emptyTitle: "There is no analytics",
            emptyMessage: ""
        ) {
            LazyVStack(spacing: DesignSystem.Spacing.medium) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxSmall) {
                    Text("Most searched in your region")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundStyle(.theme.textPrimary)
                    
                    Text("Medicines patients in your region searched for")
                        .font(.subheadline)
                        .foregroundStyle(.theme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(vm.regionalDrugDemands) { drugDemand in
                    DrugDemandView(drugDemand: drugDemand)
                }
            }
        }
    }
}

#Preview {
    AnalyticsScreen(
        pharmacyId: Pharmacy.samples[0].id,
        analyticsService: MockAnalyticsService.sample
    )
}
