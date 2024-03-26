//
//  OrderBookViewModel.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Combine
import Foundation

public class OrderBookDisplayItem: ObservableObject, Identifiable {
    var price: Double = 0.0
    var quantity: Int64 = 0
    var totalVolume: Int64 = 0

    func addItem(_ item: OrderBook.Item) {
        self.price = item.price
        self.quantity = item.size
        self.totalVolume = self.totalVolume + item.size
    }
    
    public var id: Double {
        return price
    }
    
    public var relativeVolume: Double {
        let val = (Double(self.quantity)/Double(self.totalVolume)) * 100.0
        return val
    }
}

public class OrderBookViewModel: ObservableObject {
    private var api: API<OrderBook>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    @Published var buyOrders = [OrderBookDisplayItem]()
    @Published var sellOrders = [OrderBookDisplayItem]()

    init() {
        self.api = API()
        try? self.api?.connect()
        
        self.api?.publisher
            .sink(receiveValue: {[weak self] order in
                self?.processOrder(order)
            })
            .store(in: &cancellables)
    }
    
    private func processOrder(_ order: OrderBook) {
        for item in order.data {
            switch item.side {
            case .buy:
                processBuyOrder(item)
            case .sell:
                processSellOrder(item)
            }
        }
    }
    
    private func processBuyOrder(_ item: OrderBook.Item) {
        let displayItem = buyOrders.first { $0.price == item.price } ?? OrderBookDisplayItem()
        displayItem.addItem(item)
        
        buyOrders.removeAll { $0.price == item.price }
        buyOrders.append(displayItem)
        buyOrders.sort(by: { $0.price > $1.price})
        buyOrders = Array(buyOrders.prefix(20))
    }
    
    private func processSellOrder(_ item: OrderBook.Item) {
        let displayItem = sellOrders.first { $0.price == item.price } ?? OrderBookDisplayItem()
        displayItem.addItem(item)
        
        sellOrders.removeAll { $0.price == item.price }
        sellOrders.append(displayItem)
        sellOrders.sort(by: { $1.price > $0.price})
        sellOrders = Array(sellOrders.prefix(20))
    }
}
