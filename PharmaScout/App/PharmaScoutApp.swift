//
//  PharmaScoutApp.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

@main
struct PharmaScoutApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(authService: DefaultAuthService())
//            ContentView(authService: MockAuthService())
        }
    }
}
