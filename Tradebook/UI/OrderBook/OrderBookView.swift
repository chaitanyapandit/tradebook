//
//  OrderBookView.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import SwiftUI

struct OrderBookView: View {
    @StateObject var viewModel: OrderBookViewModel

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                header
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.gray.opacity(0.2))

                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ForEach($viewModel.buyOrders) { item in
                            Cell(item: item.wrappedValue)
                                .frame(maxHeight: geometry.size.height/Double(viewModel.maxItems))
                        }
                        Spacer()
                    }
                    .clipped()
                    
                    VStack(spacing: 0) {
                        ForEach($viewModel.sellOrders) { item in
                            Cell(item: item.wrappedValue)
                                .frame(maxHeight: geometry.size.height/Double(viewModel.maxItems))
                        }
                        Spacer()
                    }
                    .clipped()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Spacer()
            Text("Qty")
            Spacer()
            Text("Price(USD)")
            Spacer()
            Text("Qty")
            Spacer()
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
    }
}

private struct Cell: View {
    @StateObject var item: OrderBookItem
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ZStack {
                    ProgressView(color: backgroundColor, progress: item.relativeVolume, direction: item.isBuy ? .leftToRight : .rightToLeft)
                    Text(String(format: "%.2f", item.price))
                        .foregroundColor(Color.ui.sellForeground)
                        .fontWeight(.bold)
                }
                .frame(width: geometry.size.width/2.0)

                Text("\(item.quantity)")
                    .frame(width: geometry.size.width/2.0)
                    .fontWeight(.medium)
            }
            .environment(\.layoutDirection, direction)
        }
    }
    
    var foregroundColor: Color {
        return item.isBuy ? .ui.buyForeground : .ui.sellForeground
    }
    
    var backgroundColor: Color {
        return item.isBuy ? .ui.buyBackground : .ui.sellBackground
    }
    
    var direction: LayoutDirection {
        return item.isBuy ? .rightToLeft : .leftToRight
    }
}

private struct ProgressView: View {
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
