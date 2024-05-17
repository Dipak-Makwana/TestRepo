//
//  Image.swift
//  SwiftuiDemo
//
//  Created by Dipak Makwana on 28/04/24.
//

import Foundation


// MARK: - ImageElement
struct ImageModel: Decodable,Identifiable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
    static var mock: ImageModel {
        ImageModel(
            albumID: 1,
            id: 1,
            title: "accusamus beatae ad facilis cum similique qui sunt",
            url: "https://via.placeholder.com/600/92c952",
            thumbnailURL: "https://via.placeholder.com/150/92c952"
        )
    }
}

struct User: Decodable,Identifiable,Hashable {
    let id: Int
    let name: String
    let username: String
    let website: String
    
    static var mock: User {
        return User(id: 1, name: "John", username: "johnde", website: "")
    }
}
struct Joke: Decodable, Hashable {
    let value: String
}
struct Category {
    let title: String
}


//typealias Image = [ImageElement]
