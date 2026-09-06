//
//  Binding+Optional.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//


import SwiftUI

extension Binding where Value == Bool {
    init<T>(optional: Binding<T?>) {
        self.init(
           get: {
               optional.wrappedValue != nil
           },
           set: { newValue in
               if !newValue {
                   optional.wrappedValue = nil
               }
           }
       )
    }
}