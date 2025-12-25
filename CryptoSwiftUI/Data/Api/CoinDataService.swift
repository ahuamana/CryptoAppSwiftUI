//
//  CoinDataService.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation
import Combine

class CoinDataservice {
    @Published var allCoins: [CoinPresentationModel] = []
    var coinSubscription: AnyCancellable?
    
    //ApiKey
    private let apiKey = "CG-RavWfeuXWAW11uj7PPxxQGU2"
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        //Use Combine
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        request.setValue(apiKey, forHTTPHeaderField: "x-cg-demo-api-key")
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                if let response = output.response as? HTTPURLResponse {
                                print("DEBUG: Status Code: \(response.statusCode)")
                                if response.statusCode == 429 {
                                    print("DEBUG: You are Rate Limited! Wait 1 minute.")
                                }
                                guard response.statusCode >= 200 && response.statusCode < 300 else {
                                    throw URLError(.badServerResponse)
                                }
                            }
                            return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure (let error):
                    if let decodingError = error as? DecodingError {
                                switch decodingError {
                                case .typeMismatch(let type, let context):
                                    print("❌ Type Mismatch: Expected \(type) but found something else.")
                                    print("   Field: \(context.codingPath.last?.stringValue ?? "Unknown")")
                                case .valueNotFound(let type, let context):
                                    print("❌ Value Not Found: Expected \(type) but it was null/missing.")
                                    print("   Field: \(context.codingPath.last?.stringValue ?? "Unknown")")
                                case .keyNotFound(let key, let context):
                                    print("❌ Key Not Found: The JSON doesn't have the key '\(key.stringValue)'.")
                                    print("   Make sure your struct matches the API exactly.")
                                case .dataCorrupted(let context):
                                    print("❌ Data Corrupted: \(context.debugDescription)")
                                @unknown default:
                                    print("❌ Unknown Decoding Error")
                                }
                            } else {
                                print("Error: \(error.localizedDescription)")
                            }
                }
            } receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins.map { coin in
                    coin.toPresentationModel()
                }
                self?.coinSubscription?.cancel()
            }
    }
}
