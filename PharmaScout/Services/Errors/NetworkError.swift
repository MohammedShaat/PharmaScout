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
    static func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet: NetworkError.notConnectedToInternet
        case .networkConnectionLost: NetworkError.networkConnectionLost
        case .cannotConnectToHost: NetworkError.cannotConnectToHost
        case .cannotFindHost: NetworkError.cannotFindHost
        case .timedOut: NetworkError.timedOut
        default: NetworkError.unknown(error)
        }
    }
}
