//
//  ButtonStyle.swift
//  PharmaScout
//
//  Created by Mohammed on 8/27/26.
//

import SwiftUI

struct GeometryReaderModifier: ViewModifier {
    var action: (GeometryProxy) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            action(geo)
                        }
                        .onChange(of: geo.frame(in: .global)) {
                            action(geo)
                        }
                }
            )
    }
}

extension View {
    func readFrame(action: @escaping (GeometryProxy) -> Void) -> some View {
        modifier(GeometryReaderModifier(action: action))
    }
}
