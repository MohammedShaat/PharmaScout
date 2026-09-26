//
//  RecentSearchesScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import SwiftUI

struct RecentSearchesScreen: View {
    @State private var vm: RecentSearchesViewModel
    
    init(authService: AuthService, searchRequestService: SearchRequestService) {
        let viewModel = RecentSearchesViewModel(
            authService: authService,
            searchRequestService: searchRequestService
        )
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, World!")
            .taskOnFirstAppear {
                await vm.loadRecentSearches()
            }
    }
}

#Preview {
    RecentSearchesScreen(
        authService: MockAuthService.sample,
        searchRequestService: MockSearchRequestService.sample
    )
}
