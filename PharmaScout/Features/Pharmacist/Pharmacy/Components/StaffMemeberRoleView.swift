//
//  StaffMemeberRoleView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/14/26.
//

import SwiftUI

struct StaffMemeberRoleView: View {
    let role: PharmacyStaffRole
    
    var body: some View {
        HStack {
            switch role {
            case .owner: Image(systemName: "crown")
            case .employee: Image(systemName: "person")
            }
            
            Text(role.title)
        }
        .foregroundStyle(role.color)
        .capsuleBackground(background: role.surfaceColor)
    }
}

extension PharmacyStaffRole {
    var color: Color {
        switch self {
        case .owner: .theme.onPrimary
        case .employee: .theme.blue
        }
    }
    
    var surfaceColor: Color {
        switch self {
        case .owner: .theme.primary
        case .employee: .theme.blueBackground
        }
    }
}

#Preview {
    CustomNavStack {
        VStack(spacing: 20) {
            StaffMemeberRoleView(role: .owner)
            StaffMemeberRoleView(role: .employee)
        }
    }
}
