//
//  RequestError.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/14/24.
//

enum RequestError: Error, Equatable {
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
    
    // To make 'unknown(Error)' case conform to Equatable, you will have to handle it.
    static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noResponse, .noResponse),
             (.unauthorized, .unauthorized),
             (.unexpectedStatusCode, .unexpectedStatusCode),
             (.decodingError, .decodingError):
            return true
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

