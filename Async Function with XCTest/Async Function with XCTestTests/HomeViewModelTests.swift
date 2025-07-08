//
//  HomeViewModelTests.swift
//  Async Function with XCTestTests
//
//  Created by Manish on 27/06/25.
//

import XCTest

@testable import Async_Function_with_XCTest

struct MockTodosService: ToDosService {
    
    var isError: Bool
    
    init(isError: Bool = false) {
        self.isError = isError
    }
    
    func getTodos() async throws -> [ToDo] {
        
        if isError {
            throw HTTPError.invalidResponse
        }
            return [ToDo(userId: 1, id: 1, title: "Test", completed: false)]
    }
}


final class HomeViewModelTests: XCTestCase {

    func testGetTodos_Success() async throws {
        
        let service = MockTodosService(isError: false)
        
        let todos = try await service.getTodos()

        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.title, "Test")
        XCTAssertEqual(todos.first?.completed, false)
    }
    
    func testGetTodos_Error() async throws {
        
        let service = MockTodosService(isError: true)
        
        do {
            let todos = try await service.getTodos()
            XCTAssertEqual(todos.count, 0)
        } catch let error as HTTPError {
            XCTAssertEqual(error, HTTPError.invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

}
