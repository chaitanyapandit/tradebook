//
//  MainView.swift
//  Tradebook
//
//  Created by Chaitanya Pandit on 26/03/24.
//

import SwiftUI

public struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    public var body: some View {
        VStack {
            OrderBookView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
}
