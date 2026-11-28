//
//  DirectionsError.swift
//  PharmaScout
//
//  Created by Mohammed on 9/24/26.
//

import Foundation

enum DirectionsError: AppError {
    case noRoute
    
    var errorDescription: String {
        switch self {
        case .noRoute: "Couldn't find a route"
            
        }
    }
}
