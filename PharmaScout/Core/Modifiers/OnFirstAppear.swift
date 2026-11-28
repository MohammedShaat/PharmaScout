//
//  OnFirstAppear.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import SwiftUI

struct OnFirstAppear: ViewModifier {
    private let action: (() -> Void)?
    @State private var firstAppear: Bool = true

    private let asyncAction: (() async -> Void)?
    @State private var firstTask: Bool = true
    
    init(action: @escaping () -> Void) {
        self.action = action
        self.asyncAction = nil
    }
    
    init(action: @escaping () async -> Void) {
        self.asyncAction = action
        self.action = nil
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if firstAppear {
                    firstAppear = false
                    action?()
                }
            }
            .task {
                if firstTask {
                    firstTask = false
                    await asyncAction?()
                }
            }
    }
}

extension View {
    func onFirstAppeary(action: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(action: action))
    }
    
    func taskOnFirstAppear(action: @escaping () async -> Void) -> some View {
        modifier(OnFirstAppear(action: action))
    }
}
