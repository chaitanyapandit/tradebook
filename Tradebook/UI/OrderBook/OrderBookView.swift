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
                ForEach($viewModel.buyOrders) { order in
                    buyOrderCell(order.wrappedValue)
                }

                Spacer()
            }
            Spacer()

            VStack() {
                ForEach($viewModel.sellOrders) { order in
                    sellOrderCell(order.wrappedValue)
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow)
    }
    
    func buyOrderCell(_ order: OrderBookDisplayItem) -> some View {
        HStack {
            Text("\(order.quantity)")
            Spacer()
            ZStack {
                progressBar(order.relativeVolume, color: .green)
                Text(String(format: "%.2f", order.price))
            }
        }
    }
    
    func sellOrderCell(_ order: OrderBookDisplayItem) -> some View {
        HStack {
            ZStack {
                progressBar(order.relativeVolume, color: .red)
                Text(String(format: "%.2f", order.price))
            }
            Spacer()
            Text("\(order.quantity)")
        }
    }
    
    func progressBar(_ progress: Double, color: Color) -> some View {
        GeometryReader { geometry in
            Rectangle()
                .frame(width: getProgressBarWidth(geometry: geometry, progress: progress))
                .opacity(0.5)
                .foregroundColor(color)
        }
    }
    
    func getProgressBarWidth(geometry: GeometryProxy, progress: Double) -> CGFloat {
        let originalWidth = geometry.size.width
        let width = (originalWidth * progress)/100.0
        return width
    }
}
