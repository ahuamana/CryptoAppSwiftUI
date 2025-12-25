//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
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
        /*dataservice.$allCoins
            .sink { (returnedCoins) in
                self.allCoins = returnedCoins
            }.store(in: &cancellables)*/
        
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
