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
    @Published var isLoading = false
    @Published var searchText: String = ""
    
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataservice()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PorfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
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
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortOption)
            .sink { [weak self] (filteredCoins) in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
        
        //Update portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedPortfolioCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedPortfolioCoins)
            }
            .store(in: &cancellables)
        
        //Update marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    func updatePortfolio(coin: CoinPresentationModel, amount:Double) {
        portfolioDataService.updatePorfolio(coin: coin, amount: amount )
    }
    
    private func mapGlobalMarketData(marketDataModel:MarketPresentationModel?, porfolioCoins: [CoinPresentationModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value:data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: "\(data.btcDominance)")
        
        let portfolioValue = porfolioCoins.map({ $0.currentHoldingsValue}).reduce(0, +)
        
        
        let previousValue = porfolioCoins.map { coin -> Double in
            print("priceChangePercentage24HInCurrency: \(coin.priceChangePercentage24HInCurrency.asCurrencyWith2Decimals())")
            let currentValue = coin.currentHoldingsValue
            let percentageChange = coin.priceChangePercentage24HInCurrency / 100
            let previousValue = currentValue / (1 + percentageChange)
            return previousValue
        }
        .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        // 110 / (1 + 10%) = 100
        
        let portFolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portFolio
        ])
        
        return stats
    }
    
    private func mapAllCoinsToPortfolioCoins(_ allCoins: [CoinPresentationModel], _ porfolioEntities: [PorfolioEntity]) -> [CoinPresentationModel] {
        allCoins
        .compactMap { (coin) -> CoinPresentationModel? in
            guard let entity = porfolioEntities.first(where: { $0.coinId == coin.id }) else {
                return nil
            }
            
            return coin.updateCurrentHoldings(entity.amount)
            
        }
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
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortOption(text:String, coins: [CoinPresentationModel], sort:SortOption) -> [CoinPresentationModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinPresentationModel]){
        switch sort {
        case .rank, .holdings:
            return coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            return coins.sort(by: { $0.rank > $1.rank })
        case .price:
            return coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case . priceReversed:
            return coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinPresentationModel]) -> [CoinPresentationModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
}
