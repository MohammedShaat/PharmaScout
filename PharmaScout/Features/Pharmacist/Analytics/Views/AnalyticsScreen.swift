//
//  AnalyticsScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/10/26.
//

import SwiftUI

struct AnalyticsScreen: View {
    @State private var vm: AnalyticsViewModel
    @State private var regionalAnalyticsTask: Task<Void, Never>?
    
    init(authService: AuthService, analyticsService: AnalyticsService) {
        let viewModel = AnalyticsViewModel(
            authService: authService,
            analyticsService: analyticsService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack {
                    periodSegmentSection
                    
                    drugDemandListSection
                }
                .padding(DesignSystem.Spacing.xLarge)
            }
            .customNavBarVisibility(false)
            .refreshable(action: vm.refresh)
            .onAppear(perform: vm.loadAnalyticsIfNeeded)
            .onDisappear {
                regionalAnalyticsTask?.cancel()
            }
            .onChange(of: vm.period) {
                regionalAnalyticsTask?.cancel()
                regionalAnalyticsTask = Task {
                    await vm.loadRegionalDemandAnalytics()
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
    
    private var drugDemandListSection: some View {
        LoadingContentView(
            LoadingState: vm.loadingState,
            isEmpty: vm.drugDemands.isEmpty,
            emptyMessage: "There is no analytics") {
                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                    ForEach(vm.drugDemands) { drugDemand in
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
        authService: MockAuthService.sample,
        analyticsService: MockAnalyticsService.sample
    )
}
