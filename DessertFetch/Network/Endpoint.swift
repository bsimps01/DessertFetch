//
//  Endpoint.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/14/24.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var scheme: String { "https" }
    var host: String { "www.themealdb.com" }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: [String: Any]? { nil }

    func makeURLRequest() throws -> URLRequest {
        // Create URLComponents
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        // Add query items if provided
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }

        // Ensure the URL is valid
        guard let url = components.url else {
            throw RequestError.invalidURL
        }

        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        // Add headers if provided
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }

        // Add body if provided and the method is POST or PUT
        if let body = body, method == .post || method == .put {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        return request
    }
}



