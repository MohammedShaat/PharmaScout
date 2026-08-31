//
//  AppErros.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//


import Foundation

protocol AppError: LocalizedError {
    var errorDescription: String { get }
}


