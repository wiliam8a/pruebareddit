//
//  Reddit.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 29/08/23.
//

import Foundation

struct Reddit: Codable {
    let kind: String
    let data: RedditData
}

struct RedditData: Codable {
    let dist: Int
    let modhash: String
    let children: [Child]

    enum CodingKeys: String, CodingKey {
        case dist, modhash
        case children
    }
}

struct Child: Codable{
    let kind: String
    let data: ChildData
}

struct ChildData: Codable {
    let title: String
}

struct ErrorMessage: Codable {
    let reason: String
    let message: String
    let error: Int
}
