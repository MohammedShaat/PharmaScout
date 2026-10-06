//
//  SectionHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/7/26.
//

import SwiftUI

struct MoreSectionHeaderView: View {
    let title: String
    var onActionTapped: (() -> Void)?
    
    var body: some View {
        SectionHeaderView(title: title, actionName: "See all") {
            Image(systemName: "chevron.right")
        } onActionTapped: {
            onActionTapped?()
        }
    }
}

#Preview {
    MoreSectionHeaderView(title: "Recent searchs")
        .padding()
}
