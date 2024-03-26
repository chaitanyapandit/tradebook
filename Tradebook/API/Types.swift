//
//  Types.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Foundation

public protocol Requestable {
   static func request() throws -> URLRequest
}

enum APIError: Error {
    case badRequest
    case badData
}

struct OrderBook: Decodable {
    
    enum Table: String, Decodable {
        case l2 = "orderBookL2"
    }
    
    enum Action: String, Decodable {
        case insert
        case delete
        case update
    }
    
    enum Side: String, Decodable {
        case buy = "Buy"
        case sell = "Sell"
    }
    
    struct Item: Decodable, Identifiable {
        var symbol: String
        var id: Int64
        var side: Side
        var size: Int64
        var price: Double
        var timestamp: String
    }
    
    let table: Table
    let action: Action
    let data: [Item]
}

extension OrderBook: Requestable {
    static func request() throws -> URLRequest {
        return try URL.request(["subscribe":"orderBookL2:XBTUSD"])
    }
}
