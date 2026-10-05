//
//  PharmacyStaffMemeberView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/5/26.
//

import SwiftUI

struct PharmacyStaffMemeberView: View {
    let member: PharmacyStaffMember
    
    var body: some View {
        HStack {
            Text(member.userInfo.fullName ?? "")
            Text(member.userInfo.email ?? "")
            Text(member.status.rawValue)
        }
    }
}

#Preview {
    PharmacyStaffMemeberView(member: .samples[0])
}
