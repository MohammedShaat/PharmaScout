//
//  PharmacyContactView.swift
//  PharmaScout
//
//  Created by Mohammed on 11/10/26.
//

import SwiftUI

struct PharmacyContactView: View {
    let contact: PharmacyContact
    
    private var domainName: String? { URL(string: contact.value)?.host() }
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            contactIcon
                .font(.system(size: 22))
                .frame(width: 30, height: 30)
                .foregroundStyle(.theme.green)
                .padding(DesignSystem.Spacing.medium)
                .roundedBackground(background: .theme.greenBackground, radius: DesignSystem.CornerRadius.small)
            
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                // Name of contact
                Text(contact.title)
                    .foregroundStyle(.theme.textPrimary)
                    .fontWeight(.bold)
                
                // Value of contact
                Group {
                    switch contact.type {
                    case .link:
                        if let domainName { Text(domainName) }
                    default:
                        Text(contact.value)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.theme.textSecondary)
            }
            Spacer()
            
            
            if contact.type == .link {
                Image(systemName: "arrow.up.forward")
                    .foregroundStyle(.theme.green)
            }
        }

    }
    
    private var contactIcon: some View {
        switch contact.type {
        case .number: Image(systemName: "phone")
        case .email: Image(systemName: "envelope")
        case .link: Image(systemName: "link")
        }
    }
    
}

#Preview {
    ZStack {
        Color.theme.background.ignoresSafeArea()
     
        VStack(spacing: 30) {
            PharmacyContactView(contact: .samples[0])
                .background(.theme.surface)
                .padding()
            
            
            PharmacyContactView(contact: .samples[1])
                .background(.theme.surface)
                .padding()
            
            PharmacyContactView(contact: .samples[3])
                .background(.theme.surface)
                .padding()
        }	
    }
}
