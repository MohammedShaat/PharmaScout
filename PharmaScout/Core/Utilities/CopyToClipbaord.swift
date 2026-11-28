//
//  CopyToClipbaord.swift
//  PharmaScout
//
//  Created by Mohammed on 11/17/26.
//

import SwiftUI

func copyToClipboard(_ text: String) {
    UIPasteboard.general.string = text
}
