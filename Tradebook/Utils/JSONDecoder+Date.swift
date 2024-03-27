//
//  JSONDecoder+Date.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 27/03/24.
//

import Foundation

extension JSONDecoder {
    static let shared: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
}
