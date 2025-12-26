//
//  MarketDataService.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketPresentationModel? = nil
    var marketSubscription: AnyCancellable?
    

    init() {
        getData()
    }
    
    func getData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }
        
        //Use Combine
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue(Constants.apiKeyValue, forHTTPHeaderField: Constants.apiKeyPrefix)

        marketSubscription = NetworkingManager.download(request: request)
            .decode(type: GlobalMarketDataModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                    self?.marketData = returnedGlobalData.data?.toPresentationModel()
                    self?.marketSubscription?.cancel()
            })
    }
}
