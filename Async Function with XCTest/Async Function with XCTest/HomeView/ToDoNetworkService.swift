//
//  ToDoNetworkService.swift
//  Async Function with XCTest
//
//  Created by Manish on 27/06/25.
//

import Foundation

protocol ToDosService {
    func getTodos() async throws -> [ToDo]
}

struct ToDoNetworkService: ToDosService {
    func getTodos() async throws -> [ToDo] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        return try await HTTPUtility.shared.getData(from: url, responseType: [ToDo].self)
    }
}
