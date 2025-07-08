//
//  HTTPUtility.swift
//  Async Function with XCTest
//
//  Created by Manish on 27/06/25.
//

import Foundation

enum HTTPError: Error, LocalizedError {
    case invalidResponse
    
    var errorDescription: String? {
        
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        }
    }
}

final class HTTPUtility {
    
    static let shared = HTTPUtility()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    func getData<T: Decodable>(from url: URL, responseType: T.Type) async throws -> T {
        
        let (data, response ) = try await session.data(from: url)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
            throw HTTPError.invalidResponse
        }
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
}
