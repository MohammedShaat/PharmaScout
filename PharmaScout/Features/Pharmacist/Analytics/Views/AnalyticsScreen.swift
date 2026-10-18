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
    
    init(staffMembership: StaffMembership, analyticsService: AnalyticsService) {
        let viewModel = AnalyticsViewModel(
            staffMembership: staffMembership,
            analyticsService: analyticsService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack {
                    analyticsTypeSection
                    
                    periodSegmentSection
                    
                    switch vm.analyticsType {
                    case .pharmacySearch:
                        pharmacySearchAnalyticsSection
                        
                    case .regional:
                        drugDemandListSection(vm.regionalDrugDemands, loadingState: vm.regionalAnalyticsLoadingState)
                    }
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .refreshable(action: vm.refresh)
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
        Menu(vm.analyticsType.title, systemImage: "chart.bar") {
            Picker("Analytics type", selection: $vm.analyticsType) {
                ForEach(AnalyticsType.allCases) { type in
                    Text(type.title)
                        .tag(type)
                }
            }
        }
    }
    
    private var periodSegmentSection: some View {
        Picker("Period", selection: $vm.period) {
            ForEach(AnalyticsPeriod.allCases) { period in
                Text(period.title)
                    .tag(period)
            }
        }
        .pickerStyle(.segmented)
        .padding(.vertical, DesignSystem.Spacing.large)
    }
    
    @ViewBuilder
    private var pharmacySearchAnalyticsSection: some View {
        LoadingContentView(
            LoadingState: vm.pharmacyAnalyticsLoadingState,
            isEmpty: vm.pharmacySearchAnalytics == nil,
            emptyMessage: "No pharmacy search analytics") {
                if let pharmacySearchAnalytics = vm.pharmacySearchAnalytics {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        HStack {
                            Text("Total drugs requested")
                            Spacer()
                            Text("\(pharmacySearchAnalytics.totalDrugsRequested)")
                        }
                        
                        HStack {
                            Text("Total drugs answered")
                            Spacer()
                            Text("\(pharmacySearchAnalytics.totalDrugsAnswered)")
                        }
                        
                        HStack {
                            Text("Total drugs answered available")
                            Spacer()
                            Text("\(pharmacySearchAnalytics.totalDrugsAnsweredAvailable)")
                        }
                    }
                    
                    drugDemandListSection(pharmacySearchAnalytics.drugDemands, loadingState: vm.pharmacyAnalyticsLoadingState)
                        .padding(.vertical, DesignSystem.Spacing.xLarge)
                }
            }
    }
    
    private func drugDemandListSection(_ drugDemands: [DrugDemand], loadingState: LoadingState) -> some View {
        LoadingContentView(
            LoadingState: loadingState,
            isEmpty: drugDemands.isEmpty,
            emptyMessage: "There is no analytics") {
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(drugDemands) { drugDemand in
                        drugDemandItem(drugDemand)
                    }
                }
            }
    }
    
    private func drugDemandItem(_ drugDemand: DrugDemand) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(drugDemand.genericName)
                    .font(.headline)
                Text(drugDemand.drugFormulation.strength)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(drugDemand.patientCount)")
                    .font(.headline)
                Text("Patient\(drugDemand.patientCount > 1 ? "s" : "")")
            }
        }	
        .background(.gray.opacity(0.3))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AnalyticsScreen(
        staffMembership: .samples[0],
        analyticsService: MockAnalyticsService.sample
    )
}
