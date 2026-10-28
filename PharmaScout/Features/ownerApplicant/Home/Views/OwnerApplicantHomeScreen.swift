//
//  OwnerApplicantHomeScreen.swift
//  PharmaScout
//
//  Created by Mohammed on 10/19/26.
//

import SwiftUI

struct OwnerApplicantHomeScreen: View {
    private let tabVM: OwnerApplicantTabViewModel
    private let ownerApplicationSummary: OwnerApplicationSummary
    
    init(
        ownerApplicantTabViewModel: OwnerApplicantTabViewModel,
        ownerApplicationSummary: OwnerApplicationSummary,
    ) {
        self.tabVM = ownerApplicantTabViewModel
        self.ownerApplicationSummary = ownerApplicationSummary
    }
    
    var body: some View {
        VStack {
            switch ownerApplicationSummary.status {
            case .approved:
                approvedSection
            case .pending:
                pendingSection
            case .rejected:
                rejectedSection
            default:
                Text("Default View")
            }
        }
        .padding(DesignSystem.Spacing.xLarge)
    }
    
    private var pendingSection: some View {
        Text("You request is pending")
            .font(.title)
    }
    
    private var rejectedSection: some View {
        VStack {
            Text("You request was rejected")
                .font(.title)
            
            Text("Please contact the admin for more information")
        }
    }
    
    private var approvedSection: some View {
        VStack {
            Text("Welcome")
                .font(.title)
            
            ActionPromptView(actionTitle: "Create pharmacy") {
                tabVM.navigateToCreatePharmacyTab()
            }
        }
    }
}

#Preview {
    OwnerApplicantHomeScreen(
        ownerApplicantTabViewModel: .sample,
        ownerApplicationSummary: .samples[0],
    )
}
