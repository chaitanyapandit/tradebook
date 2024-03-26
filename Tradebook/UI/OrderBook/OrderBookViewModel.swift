//
//  OrderBookViewModel.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import Combine

public class OrderBookHistory: ObservableObject {
    enum SortOrder {
        case ascending
        case descending
    }
    
    @Published var orders = [OrderBook.Item]()
    let sortOrder: SortOrder
    
    init(sortOrder: SortOrder = .ascending) {
        self.sortOrder = sortOrder
    }
    
    func addItem(_ item: OrderBook.Item) {
        var existingOrders = self.orders
        existingOrders.append(item)

        existingOrders.sort(by: {
            switch sortOrder {
            case .ascending:
                $1.price > $0.price
            case .descending:
                $0.price > $1.price
            }
        })
        
        existingOrders = Array(existingOrders.prefix(20))
        self.orders = existingOrders
    }
}

public class OrderBookViewModel: ObservableObject {
    private var api: API<OrderBook>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    @Published var buyOrders = OrderBookHistory(sortOrder: .descending)
    @Published var sellOrders = OrderBookHistory()

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
                buyOrders.addItem(item)
            case .sell:
                sellOrders.addItem(item)
            }
        }
    }
}
