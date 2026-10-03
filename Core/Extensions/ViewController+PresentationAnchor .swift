//
//  ViewController+PresentationAnchor .swift
//  PharmaScout
//
//  Created by Mohammed on 9/3/26.
//

import Foundation
import UIKit
import AuthenticationServices

extension UIViewController: @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
