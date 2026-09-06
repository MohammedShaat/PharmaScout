//
//  UIApplication+ViewController.swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import SwiftUI

extension UIApplication {
    var viewController: UIViewController? {
        let windowScene = connectedScenes
            .compactMap { scene in scene as? UIWindowScene }
            .first { scene in scene.activationState == .foregroundActive }
        
        return windowScene?.windows.first(where: { window in window.isKeyWindow })?.rootViewController
    }
}
