//
//  RecentTradesViewModel.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 27/03/24.
//

import Foundation
import Combine

public class RecentTradesItem: Identifiable {
    var price: Double
    var quantity: Int64
    var time: Date
    var isBuy: Bool
    var flashed: Bool = false
    
    init(data: TradeData) {
        self.price = data.price
        self.quantity = data.size
        self.time = data.timestamp
        self.isBuy = data.side == .buy
    }
    
    public var displayTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self.time)
    }
    
    public var id: Double {
        return price
    }
}

public class RecentTradesViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var tradeItems = [RecentTradesItem]()
    var maxItems = 30
    
    init() {
        try? API.shared.connect()
        
        API.shared.subscribe([WSTopic.tradeXBTUSD])
        
        API.shared.publisher
            .compactMap { message -> [RecentTradesItem]? in
                let tradeData: [TradeData] = message.data.compactMap({ data -> TradeData? in
                    return try? data.to()
                })
                return tradeData.map{RecentTradesItem(data: $0)}
            }
            .sink { [weak self] data in
                self?.processMessage(data)
            }
            .store(in: &cancellables)
    }
    
    private func processMessage(_ message: [RecentTradesItem]) {
        tradeItems.append(contentsOf: message)
        tradeItems.sort(by: { $0.time > $1.time})
        tradeItems = Array(tradeItems.prefix(maxItems))
    }
}
