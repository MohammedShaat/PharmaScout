//
//  NetworkError.swift
//  PharmaScout
//
//  Created by Mohammed on 8/31/26.
//

import Foundation

enum NetworkError: AppError {
    case notConnectedToInternet
    case networkConnectionLost
    case cannotConnectToHost
    case cannotFindHost
    case timedOut
    case unknown(URLError)

    var errorDescription: String {
        switch self {
        case .notConnectedToInternet: "No internet connection."
        case .networkConnectionLost: "Connection was lost. Try again."
        case .cannotConnectToHost: "Unable to connect. Try again."
        case .cannotFindHost: "Unable to connect. Try again."
        case .timedOut: "Request timed out. Try again."
        case .unknown: "Something went wrong with the connection. Please try again."
        }
    }
}

extension NetworkError {
    init(from error: URLError) {
        self = switch error.code {
        case .notConnectedToInternet: .notConnectedToInternet
        case .networkConnectionLost: .networkConnectionLost
        case .cannotConnectToHost: .cannotConnectToHost
        case .cannotFindHost: .cannotFindHost
        case .timedOut: .timedOut
        default: .unknown(error)
        }
    }
}
