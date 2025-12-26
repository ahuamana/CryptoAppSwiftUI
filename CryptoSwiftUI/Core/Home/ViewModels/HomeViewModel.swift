//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var statistics : [StatisticModel] = []
    
    @Published var allCoins: [CoinPresentationModel] = []
    @Published var portfolioCoins: [CoinPresentationModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataservice()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PorfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
          await addSubscribers()
        }
    }
    
    func addSubscribers() async {
        
        //Removed this becase now we suscribed two a the same time. in the searchText
        /*dataservice.$allCoins
            .sink { (returnedCoins) in
                self.allCoins = returnedCoins
            }.store(in: &cancellables)*/
        
        //Update allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (filteredCoins) in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
        
        //Update marketData
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        //Update portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map{ (coinModels, portfolioEntities) -> [CoinPresentationModel] in
                    coinModels
                    .compactMap { (coin) -> CoinPresentationModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else {
                            return nil
                        }
                        
                        return coin.updateCurrentHoldings(entity.amount)
                        
                    }
            }
            .sink { [weak self] (returnedPortfolioCoins) in
                self?.portfolioCoins = returnedPortfolioCoins
            }
            .store(in: &cancellables)
            
        
            
    }
    
    func updatePortfolio(coin: CoinPresentationModel, amount:Double) {
        portfolioDataService.updatePorfolio(coin: coin, amount: amount )
    }
    
    private func mapGlobalMarketData(marketDataModel:MarketPresentationModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value:data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: "\(data.btcDominance)")
        
        let portFolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portFolio
        ])
        
        return stats
    }
    
    private func filterCoins(text:String, coins: [CoinPresentationModel]) -> [CoinPresentationModel] {
        guard !searchText.isEmpty else {
            return coins
        }
        
        let lowercaseText = searchText.lowercased()
        
        let filteredCoins = coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercaseText) ||
            coin.symbol.lowercased().contains(lowercaseText) ||
            coin.id.lowercased().contains(lowercaseText)
        }
        
        return filteredCoins
    }
}
