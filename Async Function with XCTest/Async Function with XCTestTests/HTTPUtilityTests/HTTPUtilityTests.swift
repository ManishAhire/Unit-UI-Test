//
//  HTTPUtilityTests.swift
//  Async Function with XCTestTests
//
//  Created by Manish on 27/06/25.
//

import XCTest

@testable import Async_Function_with_XCTest

final class HTTPUtilityTests: XCTestCase {
    
    var httpUtility: HTTPUtility!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        httpUtility = HTTPUtility(session: session)
    }
    
    override func tearDown() {  
        httpUtility = nil
        MockURLProtocol.mockResponses = nil
        super.tearDown()
    }
    
    func test_getData_Success() async throws {
        
        let todo = ToDo(userId: 1, id: 1, title: "Test", completed: true)
        let jsonData = try JSONEncoder().encode(todo)
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        MockURLProtocol.mockResponses = (jsonData, response, nil)
        
        do {
            let todo = try await httpUtility.getData(from: url, responseType: ToDo.self)
            XCTAssertEqual(todo.id, 1)
        } catch {
            XCTFail("Expected successful response, but got error: \(error)")
        }
    }
    
    func test_getData_Error() async throws {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        MockURLProtocol.mockResponses = (nil, response, nil)
        
        do {
            _ = try await httpUtility.getData(from: url, responseType: ToDo.self)
            XCTFail("Expected to throw an error for invalid response")
        } catch let error as HTTPError {
            XCTAssertEqual(error, HTTPError.invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_getData_InvalidData() async throws {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let invalidJSON = "Invalid JSON".data(using: .utf8)
        MockURLProtocol.mockResponses = (invalidJSON, response, nil)
        
        do {
            _ = try await httpUtility.getData(from: url, responseType: ToDo.self)
            XCTFail("Expected to throw an error for invalid JSON")
        } catch {
            XCTAssertTrue(error is DecodingError, "Expected DecodingError but got \(error)")
        }
    }
}
