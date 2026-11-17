//
//  ReviewAction.swift
//  PharmaScout
//
//  Created by Mohammed on 10/24/26.
//

import Foundation

enum ReviewAction {
    case approve, reject
    
    var title: String {
        switch self {
        case .approve: "Approve"
        case .reject: "Reject"
        }
    }
}
