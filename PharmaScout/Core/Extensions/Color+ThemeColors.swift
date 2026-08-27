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
    let primaryLight = Color("primaryLight")
    let primaryPressed = Color("primaryPressed")
    let background = Color("background")
    let warning = Color("warning")
    
    // Info
    let disabled = Color("disabled")
    let disabledBackground = Color("disabledBackground")
    let info = Color("info")
    let infoBackground = Color("infoBackground")
    
    // Info
    let error = Color("error")
    let errorBackground = Color("errorBackground")
    let success = Color("success")
    let successBackground = Color("successBackground")
    let surface = Color("surface")
    let warningBackground = Color("warningBackground")
    
    // Info
    let border = Color("border")
    let textPrimary = Color("textPrimary")
    let textSecondary = Color("textSecondary")
}
