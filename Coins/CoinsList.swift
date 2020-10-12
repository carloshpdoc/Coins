//
//  ContentView.swift
//  Coins
//
//  Created by Carlos Henrique on 10/12/20.
//

import SwiftUI
import Combine

struct CoinsList: View {
    
   @ObservedObject private var viewModel = CoinsListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.coinsViewModels, id: \.self) { coinViewModel in
                Text(coinViewModel.displayText)
            }.onAppear {
                self.viewModel.fetchCoin()
            }.navigationBarTitle("Coins")
        }
    }
}

struct CoinsList_Previews: PreviewProvider {
    static var previews: some View {
        CoinsList()
    }
}

class CoinsListViewModel: ObservableObject {
    private let coinServiceApi = CoinServiceApi()
    
    @Published var coinsViewModels = [CoinsViewModel]()
    
    var cancellable: AnyCancellable?
    
    func fetchCoin() {
        cancellable =  coinServiceApi.fetchCoins().sink(receiveCompletion: { _ in
            
            
        },receiveValue: { coinsDataContainer in
            self.coinsViewModels = coinsDataContainer.data.coins.map { CoinsViewModel($0) }
            print(self.coinsViewModels)
        })
    }
}

struct CoinsViewModel: Hashable {
    private let coin: Coin
    
    var name: String {
        return coin.name
    }
    
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle  = .currency
        numberFormatter.locale = Locale.current
        
        guard let price = Double(coin.price), let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else { return "" }

        return formattedPrice
    }
    
    var displayText: String {
        return name + " - " + formattedPrice
    }
    
    init(_ coin: Coin) {
        self.coin = coin
    }
}
