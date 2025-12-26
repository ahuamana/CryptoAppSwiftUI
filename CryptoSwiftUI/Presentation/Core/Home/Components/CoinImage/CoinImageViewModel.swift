//
//  CoinImageViewModel.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import SwiftUI
import Combine


class CoinImageViewModel : ObservableObject {
    @Published var image : UIImage? = nil
    @Published var isLoading:Bool = false
    
    private let coin: CoinPresentationModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin:CoinPresentationModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    func addSubscribers() {
        dataService.$image
            .sink { [weak self] image in
                self?.isLoading = false
            } receiveValue: {  [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
