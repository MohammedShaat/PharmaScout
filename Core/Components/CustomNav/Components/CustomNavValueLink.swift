//
//  CustomNavValueLink.swift
//  PharmaScout
//
//  Created by Mohammed on 9/8/26.
//

import SwiftUI

struct CustomNavValueLink<H: Hashable, Label: View>: View {
    let value: H
    @ViewBuilder let label: Label
    
    var body: some View {
        NavigationLink(value: value) {
            label
        }
        .buttonStyle(.plain)
    }
}

extension View {
    func customNavigationDestination<D: Hashable, C: View>(
        for data: D.Type,
        @ViewBuilder destination: @escaping (D) -> C
    ) -> some View {
        navigationDestination(for: data) { data2 in
            CustomNavView {
                destination(data2)
                    .toolbarVisibility(.hidden, for: .navigationBar)
            }
        }
    }
}


#Preview {
    NavigationStack {
        CustomNavValueLink(value: 5)  {
            Text("Navigate")
        }
    }
}
