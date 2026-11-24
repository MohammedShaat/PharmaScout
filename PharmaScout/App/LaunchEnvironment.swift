//
//  LaunchEnvironment.swift
//  PharmaScout
//
//  Created by Mohammed on 11/24/26.
//

import Foundation

enum LaunchEnvironment {
    static let isUITesting: Bool = {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-UITestMode")
        #else
        return false
        #endif
    }()
}
