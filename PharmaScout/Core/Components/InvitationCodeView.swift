//
//  InvitationCodeView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/18/26.
//

import SwiftUI

struct InvitationCodeView: View {
    let title: String
    let invitationCode: InvitaionCode
    let shareLinkSubject: String
    let shareLinkMessage: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .multilineTextAlignment(.center)
        
        VStack(spacing: DesignSystem.Spacing.large) {
            Text(invitationCode.code)
                .font(.title2)
            
            HStack(spacing: DesignSystem.Spacing.xLarge) {
                Button {
                    UIPasteboard.general.string = invitationCode.code
                    
                } label: {
                    Image(systemName: "doc.on.doc")
                }
             
                ShareLink(
                    item: invitationCode.code,
                    subject: Text(shareLinkSubject),
                    message: Text(shareLinkMessage)
                ) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .font(.headline)
        }
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
    }
}

#Preview {
    let invitationCode: InvitaionCode = .sample
    
    InvitationCodeView(
        title: "Share this 6-character code with staff members who want to join your pharmacy.",
        invitationCode: invitationCode,
        shareLinkSubject: "Pharmacy Join Code",
        shareLinkMessage: "Use this code to join our pharmacy."
    )
}
