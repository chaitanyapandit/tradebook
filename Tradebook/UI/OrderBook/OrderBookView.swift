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
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    ForEach($viewModel.buyOrders) { order in
                        buyOrderCell(order.wrappedValue)
                    }
                }
                
                VStack(spacing: 0) {
                    ForEach($viewModel.sellOrders) { order in
                        sellOrderCell(order.wrappedValue)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func buyOrderCell(_ order: OrderBookDisplayItem) -> some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Text("\(order.quantity)")
                    .frame(width: geometry.size.width/2.0)
                    .fontWeight(.medium)

                ZStack(alignment: .center) {
                    ProgressView(color: .ui.buyBackground, progress: order.relativeVolume, direction: .leftToRight)
                    Text(String(format: "%.2f", order.price))
                        .foregroundColor(Color.ui.buyForeground)
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    func sellOrderCell(_ order: OrderBookDisplayItem) -> some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ZStack {
                    ProgressView(color: .ui.sellBackground, progress: order.relativeVolume, direction: .rightToLeft)
                    Text(String(format: "%.2f", order.price))
                        .foregroundColor(Color.ui.sellForeground)
                        .fontWeight(.bold)
                }
                .frame(width: geometry.size.width/2.0)

                Text("\(order.quantity)")
                    .frame(width: geometry.size.width/2.0)
                    .fontWeight(.medium)
            }
        }
    }
}

struct ProgressView: View {
    let color: Color
    let progress: Double
    let direction: LayoutDirection
        
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .frame(width: getProgressBarWidth(geometry: geometry, progress: progress))
                    .foregroundColor(color)
            }
            .environment(\.layoutDirection, direction)
        }
    }
    
    func getProgressBarWidth(geometry: GeometryProxy, progress: Double) -> CGFloat {
        let originalWidth = geometry.size.width
        let width = (originalWidth * progress)/100.0
        return min(originalWidth, width)
    }
}
