//
//  SearchDetailScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/27/26.
//

import SwiftUI

struct SearchDetailScreen: View {
    private let patientTabViewModel: PatientTabViewModel
    @State private var vm: SearchDetailViewModel
    
    init(
        searchRequestService: SearchRequestService,
        locationService: LocationService,
        patientTabViewModel: PatientTabViewModel,
        search: Search
    ) {
        self.patientTabViewModel = patientTabViewModel
        let viewModel = SearchDetailViewModel(
            searchRequestService: searchRequestService,
            locationService: locationService,
            search: search
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                
                VStack(alignment: .leading) {
                    Text("Accept substitute: \(vm.search.acceptSubstitute.description)")
                    Text("Fulfilment mode: \(vm.search.fulfilmentMode.rawValue)")
                    Text("Status: \(vm.search.status.rawValue)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                LoadingContentView(
                    LoadingState: vm.loadingState,
                    isEmpty: vm.searchDrugDetails.isEmpty,
                    emptyMessage: "There is no details") {
                        LazyVStack(spacing: DesignSystem.Spacing.medium) {
                            ForEach(vm.searchDrugDetails) { searchDrugDetail in
                                searchDrugDetailItem(searchDrugDetail)
                            }
                        }
                    }
                
            }
            .padding(DesignSystem.Spacing.xLarge)
        }
        .refreshable(action: vm.refresh)
        .taskOnFirstAppear {
            await vm.loadSearchDetail()
        }
    }
    
    private func searchDrugDetailItem(_ searchDrugDetail: SearchDrugDetail) -> some View {
        VStack(alignment: .leading) {
            Text(searchDrugDetail.genericName)
            Text(searchDrugDetail.drugFormulation.title)
            
            HStack {
                Spacer()
                
                // Still pending
                if searchDrugDetail.status == .pending {
                    Text("Waiting")
                    
                } else {
                    // There is reponse from a pharmacy
                    if let response = searchDrugDetail.response {
                        VStack {
                            Text(response.pharmacyResponse.rawValue)
                            
                            Text(response.pharmacy.name)
                                .clickable {
                                    patientTabViewModel.navigateToPharmacyDetailScreen(for: response.pharmacy)
                                }
                        }
                        
                    // No response
                    } else {
                        Text("No response")
                    }
                }
                
            }
            
            if searchDrugDetail.response?.pharmacyResponse == .substitute,
               let response = searchDrugDetail.response,
               let substituteGenericName = response.substituteGenericName,
               let substituteFormulation = response.substituteDrugFormulation {
                Text(substituteGenericName)
                Text(substituteFormulation.title)
            }
        }
        .background(.gray.opacity(0.3))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SearchDetailScreen(
        searchRequestService: MockSearchRequestService.sample,
        locationService: MockLocationService.sample,
        patientTabViewModel: PatientTabViewModel.sample,
        search: .samples[1]
    )
}
