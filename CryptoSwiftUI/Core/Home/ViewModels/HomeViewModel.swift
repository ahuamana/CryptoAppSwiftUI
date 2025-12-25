//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var statistics : [StatisticModel] = [
        StatisticModel(title: "Bitcoin", value: "123456789", percentageChange: 1),
        StatisticModel(title: "Ethereum", value: "123456789"),
        StatisticModel(title: "Title", value: "123456789"),
        StatisticModel(title: "Tether", value: "123456789", percentageChange: -7),
    ]
    
    @Published var allCoins: [CoinPresentationModel] = []
    @Published var portfolioCoins: [CoinPresentationModel] = []
    
    @Published var searchText: String = ""
    
    private let dataservice = CoinDataservice()
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
            .combineLatest(dataservice.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (filteredCoins) in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
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
