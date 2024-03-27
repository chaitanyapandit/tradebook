//
//  OrderBookViewModel.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Combine
import Foundation

public class OrderBookItem: ObservableObject, Identifiable {
    var price: Double = 0.0
    var quantity: Int64 = 0
    var totalVolume: Int64 = 0
    var isBuy: Bool = false

    func update(data: OrderBookData) {
        self.price = data.price
        self.quantity = data.size
        self.totalVolume = self.totalVolume + data.size
        self.isBuy = data.side == .buy
    }
    
    public var id: Double {
        return price
    }
    
    public var relativeVolume: Double {
        return (Double(self.quantity)/Double(self.totalVolume)) * 100.0
    }
}

public class OrderBookViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var buyOrders = [OrderBookItem]()
    @Published var sellOrders = [OrderBookItem]()
    var maxItems = 20

    init() {
        try? API.shared.connect()
        
        API.shared.subscribe([WSTopic.orderBookL2XBTUSD])
        
        API.shared.publisher
            .compactMap { message -> [OrderBookData]? in
                let orderbookData: [OrderBookData] = message.data.compactMap({ data -> OrderBookData? in
                    return try? data.to()
                })
                return orderbookData
            }
            .sink { [weak self] data in
                self?.processOrders(data)
            }
            .store(in: &cancellables)
    }
        
    private func processOrders(_ datas: [OrderBookData]) {
        for data in datas {
            if data.side == .buy {
                let item = buyOrders.first { $0.price == data.price } ?? OrderBookItem()
                item.update(data: data)
                buyOrders.removeAll { $0.price == data.price }
                buyOrders.append(item)
            } else {
                let item = sellOrders.first { $0.price == data.price } ?? OrderBookItem()
                item.update(data: data)
                sellOrders.removeAll { $0.price == data.price }
                sellOrders.append(item)
            }
        }
        
        buyOrders.sort(by: { $0.price > $1.price})
        buyOrders = Array(buyOrders.prefix(maxItems))
        sellOrders.sort(by: { $1.price > $0.price})
        sellOrders = Array(sellOrders.prefix(maxItems))
    }
}
