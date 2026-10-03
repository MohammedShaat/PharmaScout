//
//  PharmacistHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 9/29/26.
//

import SwiftUI

struct PharmacistHomeScreen: View {
    @State private var vm: PharmacistHomeViewModel
    
    init(authService: AuthService) {
        let viewModel = PharmacistHomeViewModel(authService: authService)
        self._vm = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        CustomNavStack {
            ScrollView {
                VStack {
                    
                    if !vm.isAuthorized {
                        Text("Your're not authorized yet")
                            .font(.largeTitle)
                    }
                    
                }
                .padding(DesignSystem.Spacing.xLarge)
                .customNavBarVisibility(false)
            }
        }
    }
}

#Preview {
    PharmacistHomeScreen(authService: MockAuthService.sample)
}
