//
//  CoinDataService.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation
import Combine

class CoinDataservice {
    @Published var allCoins: [CoinPresentationModel] = []
    var coinSubscription: AnyCancellable?
 
    init() {
        getCoins()
    }
    
    func getCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        //Use Combine
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue(Constants.apiKeyValue, forHTTPHeaderField: Constants.apiKeyPrefix)
        
        coinSubscription = NetworkingManager.download(request: request)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                    self?.allCoins = returnedCoins.map { coin in
                        coin.toPresentationModel()
                    }
                    self?.coinSubscription?.cancel()
            })
    }
}
