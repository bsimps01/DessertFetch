//
//  RequestError.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/14/24.
//

enum RequestError: Error {
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case decodingError
    case unknown(Error)
    
    var customMessage: String {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noResponse: return "No response from the server."
        case .unauthorized: return "Unauthorized request."
        case .unexpectedStatusCode: return "Unexpected status code."
        case .decodingError: return "Failed to decode response."
        case .unknown(let error): return "Unknown error: \(error.localizedDescription)"
        }
    }
}

