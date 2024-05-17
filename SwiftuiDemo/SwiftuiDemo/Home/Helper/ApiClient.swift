//
//  ApiClient.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 29/04/24.
//

import Foundation
import Combine
import Network


enum YourAppError: Error {
    case internetNotFound
    
    static func error(for defaultError: Error) -> Self {
        .internetNotFound
    }
}

class ApiClient {
    
    let monitor = NWPathMonitor()
    
    init() {
        checkInternet()
    }
    
    private func checkInternet() {
       // let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connection is reachable.")
            } else {
                print("No connection.")
            }
        }
    }
    
    func load<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .mapError { error in YourAppError.error(for: error) }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchData<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw ErrorType.badServerResponse//URLError(.badServerResponse)
                }
                return result.data
            }
            //.map { result.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
