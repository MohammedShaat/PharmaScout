//
//  Binding+Optional.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//


import SwiftUI

extension Binding where Value == Bool {
    init<T>(
        optionalValue: T?,
        onPresentationChange: ((Bool) -> Void)? = nil
    ) {
        self.init(
           get: {
               optionalValue != nil
           },
           set: { isPresented in
               onPresentationChange?(isPresented)
           }
       )
    }
    
    init<T>(optionalValue: Binding<T?>) {
        self.init(
           get: {
               optionalValue.wrappedValue != nil
           },
           set: { isPresented in
               if !isPresented { optionalValue.wrappedValue = nil }
           }
       )
    }
}
