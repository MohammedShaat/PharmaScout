//
//  UnknownError.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//


import Foundation

enum UnknownError: AppError {
    case unKnown(Error)
    
    var errorDescription: String {
        "Something went wrong."
    }
}
