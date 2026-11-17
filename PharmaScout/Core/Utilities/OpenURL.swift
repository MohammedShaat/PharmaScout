//
//  OpenURL.swift
//  PharmaScout
//
//  Created by Mohammed on 11/18/26.
//

import SwiftUI

func open(_ url: URL?, by handler: OpenURLAction) {
    guard let url else { return }
    handler(url)
}
