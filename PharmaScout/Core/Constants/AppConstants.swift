//
//  AppConstants.swift
//  PharmaScout
//
//  Created by Mohammed on 9/9/26.
//

import Foundation

enum AppConstants {
    enum Timing {
        static let searchDebounceInterval: Duration = .milliseconds(500)
    }
    
    enum Network {
        static let smallPageSize = 10
    }
}
