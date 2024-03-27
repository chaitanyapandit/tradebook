//
//  Types.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Foundation
import AnyCodable

public protocol Requestable {
   static func request() throws -> URLRequest
}

enum APIError: Error {
    case badRequest
    case badData
    case badCommand
}

public extension AnyCodable {
    func to<T: Decodable>() throws -> T {
        return try JSONDecoder.shared.decode(T.self, from: JSONEncoder().encode(self))
    }
}

public struct OrderBookData: Decodable, Identifiable {
    public var symbol: String
    public var id: Int64
    public var side: Side
    public var size: Int64
    public var price: Double
    public var timestamp: Date
}

public struct TradeData: Decodable, Identifiable {
    public var timestamp: Date
    public var symbol: String
    public var trdMatchID: String
    public var side: Side
    public var size: Int64
    public var price: Double
    
    public var id: String {
        return trdMatchID
    }
}

public enum Table: String, Decodable {
    case orderBookL2 = "orderBookL2"
    case trade = "trade"
}

public enum Action: String, Decodable {
    case insert
    case delete
    case update
}

public enum Side: String, Decodable {
    case buy = "Buy"
    case sell = "Sell"
}

public struct WSMessage: Decodable {
    let table: Table
    let action: Action
    let data: [AnyCodable]
}

public enum WSOperation: String, Encodable {
    case subscribe
}

public enum WSTopic: String, Encodable {
    case orderBookL2XBTUSD = "orderBookL2:XBTUSD"
    case tradeXBTUSD = "trade:XBTUSD"
}

public struct WSCommand: Encodable {
    let op: String
    let args: [String]
}
