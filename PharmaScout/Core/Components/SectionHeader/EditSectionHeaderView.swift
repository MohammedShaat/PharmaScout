//
//  EditSectionHeaderView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/6/26.
//

import SwiftUI

struct EditSectionHeaderView: View {
    let title: String
    var onActionTapped: (() -> Void)?
    
    var body: some View {
        SectionHeaderView(title: title, actionName: "Edit") {
            Image(systemName: "pencil")
        } onActionTapped: {
            onActionTapped?()
        }
    }
}

#Preview {
    EditSectionHeaderView(title: "Address")
        .padding()
}
