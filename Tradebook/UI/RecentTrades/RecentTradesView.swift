//
//  RecentTradesView.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 27/03/24.
//

import SwiftUI

struct RecentTradesView: View {
    @StateObject var viewModel = RecentTradesViewModel()
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                header
                
                VStack(spacing: 0) {
                    ForEach($viewModel.tradeItems) { item in
                        cell(item.wrappedValue)
                            .frame(maxHeight: geometry.size.height/Double(viewModel.maxItems))
                    }
                    Spacer()
                }
            }
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
    
    
    private func cell(_ item: RecentTradesItem) -> some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView(color: item.isBuy ? Color.ui.buyBackground : Color.ui.sellBackground)

                HStack(spacing: 0) {
                    Text(String(format: "%.1f", item.price))
                        .frame(width: geometry.size.width/3.0)
                        .fontWeight(.medium)
                    
                    Text(String(item.quantity))
                        .frame(width: geometry.size.width/3.0)
                        .fontWeight(.medium)

                    Text("\(item.displayTime)")
                        .frame(width: geometry.size.width/3.0)
                        .fontWeight(.medium)
                }
                .foregroundColor(item.isBuy ? Color.ui.buyForeground : Color.ui.sellForeground)
            }
        }
    }
}

struct BackgroundView: View {
    @State var opacity: Double = 1
    @State var color: Color
    
    public var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .opacity(opacity)
                .foregroundColor(color)
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 0.2)
                    withAnimation(baseAnimation) {
                        opacity = 0
                    }
                }
        }
    }
}
