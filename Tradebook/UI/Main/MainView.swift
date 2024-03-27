//
//  MainView.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import SwiftUI

public struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @StateObject var recentTradesViewModel = RecentTradesViewModel()
    @StateObject var orderbookViewModel = OrderBookViewModel()

    @State private var selectedTab: Int = 0

    public var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Order Book").tag(0)
                Text("Recent Trades").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())

            switch(selectedTab) {
            case 0: OrderBookView(viewModel: orderbookViewModel)
                default: RecentTradesView(viewModel: recentTradesViewModel)
            }
        }
    }
}
