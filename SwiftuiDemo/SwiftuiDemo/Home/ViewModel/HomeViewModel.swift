//
//  HomeViewModel.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 26/04/24.
//

import SwiftUI
import Combine

protocol HomeServiceProtocol {
    func fetchUsers() throws
    func fetchPhotos() throws
}
class HomeViewModel: ObservableObject {
    
    let apiClient: ApiClient
    private var cancellble = Set<AnyCancellable>()
    @Published var users: [User] = []
    @Published var images: [ImageModel] = []
    @Published var appError: DemoError?
    
    init(_ apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }
    
    var first20Images: [ImageModel] {
        return  Array(images.prefix(20))
    }
}
// private methods
extension HomeViewModel: HomeServiceProtocol {
    
    func fetchUsers() throws {
        
        guard let url = URL(string: URLString.users.path) else {
            throw ErrorType.badURL
        }
        perfomeOperationsOn(apiClient.fetchData(url: url), handler: { [weak self] value  in
            guard let self = self else { return }
            self.users = (value ?? []) ?? []
        })
    }
    
    private func perfomeOperationsOn<T: Decodable>(_ publisher: AnyPublisher<T, Error>, handler: @escaping (T?) -> Void) {
        return publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    debugPrint(completion)
                case .failure(let error):
                    self.appError = DemoError(error,error.localizedDescription)
                }
            }, receiveValue: { values in
                handler(values)
            })
            .store(in: &cancellble)
    }
    func fetchPhotos() throws {
        guard let url = URL(string: URLString.images.path) else {
            throw ErrorType.badURL
        }
        perfomeOperationsOn(apiClient.fetchData(url: url), handler: { [weak self] images  in
            guard let self = self else { return }
            self.images = images ?? []
        })
    }
    
    private func checkBadURL(urlString: String) throws {
        guard let _ = URL(string: urlString) else {
            throw ErrorType.badURL
        }
    }
}
