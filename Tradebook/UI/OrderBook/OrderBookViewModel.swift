//
//  OrderBookViewModel.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Combine

public class OrderBookViewModel: ObservableObject {
    private var api: API<OrderBook>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    @Published var buyOrders = [OrderBook.Item]()
    @Published var sellOrders = [OrderBook.Item]()

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
                buyOrders.append(item)
            case .sell:
                sellOrders.append(item)
            }
        }
        
        buyOrders.sort(by: { $1.price > $0.price})
        buyOrders = Array(buyOrders.prefix(20))

        sellOrders.sort(by: { $0.price > $1.price})
        sellOrders = Array(sellOrders.prefix(20))
    }
}
