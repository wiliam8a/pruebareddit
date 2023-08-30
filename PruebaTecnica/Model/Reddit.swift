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
    let after: String
    let dist: Int
    let modhash: String
    let geoFilter: JSONNull?
    let children: [Child]
    let before: JSONNull?

    enum CodingKeys: String, CodingKey {
        case after, dist, modhash
        case geoFilter
        case children, before
    }
}

struct Child: Codable{
//    var id = UUID()
    let kind: String
    let data: ChildData
}

struct ChildData: Codable {
    let title: String
}

class JSONNull: Codable, Hashable { 

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
