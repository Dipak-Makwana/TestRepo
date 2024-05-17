//
//  NetworkMonitor.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 09/05/24.
//

import Foundation
import Network

@Observable
final class NetworkMonitor: ObservableObject {
    private var networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}
