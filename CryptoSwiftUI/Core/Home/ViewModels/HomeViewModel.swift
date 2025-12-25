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
        dataservice.$allCoins
            .sink { (returnedCoins) in
                self.allCoins = returnedCoins
            }.store(in: &cancellables)
    }
}
