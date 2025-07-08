//
//  MockURLProtocol.swift
//  Async Function with XCTestTests
//
//  Created by Manish on 08/07/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var mockResponses: (Data?, URLResponse?, Error?)?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if let (data, response, error) = MockURLProtocol.mockResponses {
            
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                
                if let response = response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                
                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                
                client?.urlProtocolDidFinishLoading(self)
                
            }
        }
        
    }
    
    override func stopLoading() {
        // No cleanup needed for mock protocol
    }
}
