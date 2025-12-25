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
    
    private let fileManager = LocalFileManager.instance
    private let folderName = "coins_images"
    private let imageName:String
    
    init(coin:CoinPresentationModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
            print("Retrieved image from File Manager!")
        } else {
            downloadCoinImage()
            print("Downloading image from URL!")
        }
    }
    
    func downloadCoinImage(){
        guard let url = URL(string: coin.image) else {
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
                    guard
                        let self = self,
                        let downloadImage = returnedImage
                else { return }
                    self.image = returnedImage
                    self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
            })
        
    }
    
    
}
