//
//  Color+ThemeColors.swift
//  PharmaScout
//
//  Created by Mohammed on 8/26/26.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var theme: ThemeColors {
        ThemeColors()
    }
}

struct ThemeColors {
    // Core
    let primary = Color("primaryBrandColor")
    let primaryPressed = Color("primaryPressed")
    let onPrimary = Color("onPrimary")
    let secondary = Color("secondaryBrand")
    let secondaryStrong = Color("secondaryStrong")
    let background = Color("background")
    let canvas = Color("canvas")
    let surface = Color("surface")
    
    // State
    let error = Color("error")
    let errorText = Color("errorText")
    let success = Color("success")
    let border = Color("border")
    let borderFilled = Color("borderFilled")
    let borderFocused = Color("borderFocused")
    let disabledBackground = Color("disabledBackground")
    let disabledContent = Color("disabledContent")
    
    // Text
    let textPrimary = Color("textPrimary")
    let textSecondary = Color("textSecondary")
    let textLabel = Color("textLabel")
    let textTertiary = Color("textTertiary")
}
