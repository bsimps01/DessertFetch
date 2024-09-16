//
//  Endpoint.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/14/24.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }  // Query parameters (like ?c=Dessert)
    var body: [String: Any]? { get }         // Only used for POST/PUT requests
}

extension Endpoint {
    var scheme: String { "https" }
    var host: String { "www.themealdb.com" }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: [String: Any]? { nil }

    func makeURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        // Add query items for GET requests
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers if available
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        // Add body if available for POST/PUT requests (not for GET requests)
        if let body = body, method == .post || method == .put {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
}

