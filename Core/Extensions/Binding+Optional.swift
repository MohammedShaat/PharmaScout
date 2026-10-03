//
//  Binding+Optional.swift
//  PharmaScout
//
//  Created by Mohammed on 8/30/26.
//


import SwiftUI

extension Binding where Value == Bool {
    init<T>(optionalValue: T?) {
        self.init(
           get: {
               optionalValue != nil
           },
           set: { _ in }
       )
    }
}
