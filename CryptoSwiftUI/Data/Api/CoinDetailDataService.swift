//
//  CoinDetailDataService.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 26/12/25.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailPresentationModel? = nil
    
    var coinDetailSubscription: AnyCancellable?
    let coin:CoinPresentationModel
    
    init(coin:CoinPresentationModel) {
        self.coin = coin
        getCoinDetails(coin: coin)
    }
    
    func getCoinDetails(coin:CoinPresentationModel) {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
            return
        }
        
        //Use Combine
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue(Constants.apiKeyValue, forHTTPHeaderField: Constants.apiKeyPrefix)
        
        coinDetailSubscription = NetworkingManager.download(request: request)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinsDetails) in
                    self?.coinDetails = returnedCoinsDetails.toPresentationModel()
                    self?.coinDetailSubscription?.cancel()
            })
    }
}
