//
//  HomeViewModel.swift
//  Async Function with XCTest
//
//  Created by Manish on 27/06/25.
//

import Foundation
import Observation

struct ToDo: Decodable, Encodable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

@MainActor
@Observable
final class HomeViewModel {
    
    private let service: ToDosService
    
    var todos: [ToDo] = []
    var errorMessage: String = String()
    
    init(service: ToDosService = ToDoNetworkService()) {
        self.service = service
    }
    
    func getToDos() async  {
        do {
            todos = try await service.getTodos()
            print("Todo: \(todos)")
        } catch (let error) {
            errorMessage = error.localizedDescription
            print("Error: \(errorMessage)")
        }
    }
}
