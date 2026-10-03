//
//  String+Trimmed.swift
//  PharmaScout
//
//  Created by Mohammed on 9/9/26.
//

import Foundation

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
