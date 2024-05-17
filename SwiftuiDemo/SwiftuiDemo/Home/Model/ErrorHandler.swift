//
//  ErrorHandler.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 29/04/24.
//

import Foundation

enum ErrorType: Error,LocalizedError {
    case badURL
    case badURLOfUser
    case invalidJSONResponse
    case networkError
    case badServerResponse 
    
    var errorDescription: String? {
        switch self {
       
        case .badURL:
            NSLocalizedString("Invalid URL", comment: "")
        case .invalidJSONResponse:
            NSLocalizedString("invalidJSONResponse", comment: "")
        case .networkError: strInternetNotAvailable
        case .badServerResponse:
            NSLocalizedString("badServerResponse", comment: "")
        case .badURLOfUser:
            NSLocalizedString("Invalid User URL", comment: "")
        }
    }
}

class DemoError: Identifiable,ObservableObject {
    let id = UUID().uuidString
    var error: Error?
    var instruction: String? = nil
    // to display error in alert
    var isNeedToDisplay: Bool
    
    init(_ error: Error? = nil, _ instruction: String? = nil, isNeedToDisplay: Bool = false ) {
        self.error = error
        self.instruction = instruction
        self.isNeedToDisplay = isNeedToDisplay
    }
}
