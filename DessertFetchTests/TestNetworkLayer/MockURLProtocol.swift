//
//  MockURLProtocol.swift
//  DessertFetch
//
//  Created by Benjamin Simpson on 9/20/24.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    // Determine whether this protocol can handle the request
    override class func canInit(with request: URLRequest) -> Bool {
        return true  // We handle all requests in the mock
    }

    // Return the same request that was passed in
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    // Start the loading of the mock response
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is not set.")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    // Stop loading
    override func stopLoading() {
        // No cleanup needed
    }
}
