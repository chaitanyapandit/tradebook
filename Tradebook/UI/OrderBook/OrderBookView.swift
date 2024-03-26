//
//  OrderBookView.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import SwiftUI

struct OrderBookView: View {
    @ObservedObject var viewModel = OrderBookViewModel()

    public var body: some View {
        VStack() {
            Text("Something")
            ForEach($viewModel.buyOrders.orders) { order in
                HStack {
                    Text("\(order.size)")
                    Text("\(order.price)")
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow)
    }
}
