//
//  CoinImageService.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    @Published var image: UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    
    private let coin:CoinPresentationModel
    
    init(coin:CoinPresentationModel) {
        self.coin = coin
        getCoinImage()
    }
    
    func getCoinImage(){
        
        guard let url = URL(string: coin.image ) else {
            return
        }
        
        //Use Combine
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        imageSubscription = NetworkingManager.download(request: request)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data:data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                    self?.image = returnedImage
                    self?.imageSubscription?.cancel()
            })
        
    }
    
    
}
