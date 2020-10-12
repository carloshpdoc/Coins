//
//  CoinServiceApi.swift
//  Coins
//
//  Created by Carlos Henrique on 10/12/20.
//

import Foundation
import Combine

final class CoinServiceApi {
    var components:  URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coinranking.com"
        components.path = "/v1/public/coins"
        components.queryItems = [URLQueryItem(name: "base", value: "BRL"), URLQueryItem(name: "timePeriod", value: "24h")]
        
        return components
    }
    
    func fetchCoins() -> AnyPublisher<CoinsDataContainer, Error> {
        return URLSession.shared.dataTaskPublisher(for: components.url!).map { $0.data }
            .decode(type: CoinsDataContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct CoinsDataContainer: Decodable {
    let status: String
    let data: CoinsData
}

struct CoinsData: Decodable {
    let coins: [Coin]
}

struct Coin: Decodable, Hashable {
    let name: String
    let price: String
    
}
