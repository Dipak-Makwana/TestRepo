//
//  URLString.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 29/04/24.
//

import Foundation

enum URLString {
    case users
    case images
    
    var path: String {
        switch self {
        case .users:
            "https://jsonplaceholder.typicode.com/users"
        case .images:
            "https://jsonplaceholder.typicode.com/photos"
        }
    }
}
