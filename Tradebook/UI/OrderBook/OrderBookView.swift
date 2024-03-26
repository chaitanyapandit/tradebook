//
//  OrderBookView.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import SwiftUI

struct OrderBookView: View {
    @StateObject var viewModel = OrderBookViewModel()

    public var body: some View {
        HStack {
            VStack() {
                ForEach(viewModel.buyOrders) { order in
                    HStack {
                        Text("\(order.size)")
                        Spacer()
                        Text("\(order.price)")
                    }
                }

                Spacer()
            }

            VStack() {
                ForEach(viewModel.sellOrders) { order in
                    HStack {
                        Text("\(order.size)")
                        Spacer()
                        Text("\(order.price)")
                    }
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow)
    }
}
