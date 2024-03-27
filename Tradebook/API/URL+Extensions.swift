//
//  URL+Extensions.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Foundation

extension URL {
    static let baseURL: URL = {
        return URL(string: "wss://ws.bitmex.com/realtime")!
    }()
    
    static func request(_ params: [String: String] = [:]) throws -> URLRequest {
        guard var urlcomps = URLComponents(string: URL.baseURL.absoluteString) else {
            throw APIError.badRequest
        }
                
        urlcomps.queryItems = params.map({ (key, val) in
            URLQueryItem(name: key, value: val)
        })
        
        guard let url = urlcomps.url else {
            throw APIError.badRequest
        }
        
        return URLRequest(url: url)
    }
}
