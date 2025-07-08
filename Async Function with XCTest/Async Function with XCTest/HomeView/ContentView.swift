//
//  ContentView.swift
//  Async Function with XCTest
//
//  Created by Manish on 27/06/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var homeVM = HomeViewModel(service: ToDoNetworkService())
    
    var body: some View {
        NavigationStack {
            
            List(homeVM.todos) { todo in
                
                VStack(alignment: .leading) {
                    Text(todo.title)
                        .font(.headline)
                    Text(todo.completed ? "Completed" : "Pending")
                        .font(.subheadline)
                        .foregroundStyle(todo.completed ? .green : .red)
                }
                
            }
            .navigationTitle("ToDos")
            .task {
                await homeVM.getToDos()
            }
            .alert("Error", isPresented: .constant(!homeVM.errorMessage.isEmpty)) {
                Button("Ok") {
                    homeVM.errorMessage = ""
                }
            } message: {
                Text(homeVM.errorMessage)
            }

        }
        
    }
}

#Preview {
    ContentView()
}
