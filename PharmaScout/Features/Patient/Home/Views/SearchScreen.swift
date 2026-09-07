//
//  SearchScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct SearchScreen: View {
    @State private var vm: SearchViewModel
    
    init(drugService: DrugService) {
        let viewModel = SearchViewModel(drugSerice: drugService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Search medicine", text: $vm.searchText)
                    .padding()
                    .background(.theme.disabledBackground)
                
                if vm.isLoading {
                    RingProgressView()
                }
                
                ForEach(vm.genericDrugs) { genericDrug in
                    Text(genericDrug.genericName)
                }
            }
            .padding(Spacing.xLarge)
            .errorAlert(title: "Search failed", error: $vm.searchError)
            .task(id: vm.searchText) {
                await vm.autoComplete()
            }
        }
    }
}

#Preview {
    CustomNavStack {
        SearchScreen(drugService: MockDrugService.sample)
    }
}
