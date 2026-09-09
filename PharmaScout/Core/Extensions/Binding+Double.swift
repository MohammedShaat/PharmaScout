//
//  Binding+Double.swift
//  PharmaScout
//
//  Created by Mohammed on 9/13/26.
//

import SwiftUI

extension Binding where Value == Double {
    init(intValue: Binding<Int>) {
        self.init(
            get: {
                Double(intValue.wrappedValue)
            },
            set: { newValue in
                intValue.wrappedValue = Int(newValue)
            }
        )
    }
}
