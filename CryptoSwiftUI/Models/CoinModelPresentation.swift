//
//  CoinModelPresentation.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation


struct CoinPresentationModel:Identifiable {
    let id, symbol, name :String
    let image: String
    let currentPrice:Double
    let marketCap, marketCapRank, fullyDilutedValuation:Int
    let totalVolume, high24H, low24H:Double
    let priceChange24H, priceChangePercentage24H: Double
    let marketCapChange24H: Double
    let marketCapChangePercentage24H: Double
    let circulatingSupply, totalSupply, maxSupply, ath:Double
    let athChangePercentage: Double
    let athDate: String
    let atl, atlChangePercentage:Double?
    let atlDate:String
    let lastUpdated: String
    let sparklineIn7D: SparklineIn7DPresentationModel
    let priceChangePercentage24HInCurrency: Double
    let currentHoldings:Double
    
    var currentHoldingsValue: Double {
        return currentHoldings * currentPrice
    }
    var rank:Int {
        return Int(marketCapRank)
    }
    
}


struct SparklineIn7DPresentationModel {
    let price: [Double]
}

extension CoinPresentationModel {
    func copy(
        currentHoldings: Double? = nil,
        id: String? = nil
    ) -> CoinPresentationModel {
        
        return CoinPresentationModel(
            id: id ?? self.id,
            symbol: self.symbol,
            name: self.name,
            image: self.image,
            currentPrice: self.currentPrice,
            marketCap: self.marketCap,
            marketCapRank: self.marketCapRank,
            fullyDilutedValuation: self.fullyDilutedValuation,
            totalVolume: self.totalVolume,
            high24H: self.high24H,
            low24H: self.low24H,
            priceChange24H: self.priceChange24H,
            priceChangePercentage24H: self.priceChangePercentage24H,
            marketCapChange24H: self.marketCapChange24H,
            marketCapChangePercentage24H: self.marketCapChangePercentage24H,
            circulatingSupply: self.circulatingSupply,
            totalSupply: self.totalSupply,
            maxSupply: self.maxSupply,
            ath: self.ath,
            athChangePercentage: self.athChangePercentage,
            athDate: self.athDate,
            atl: self.atl,
            atlChangePercentage: self.atlChangePercentage,
            atlDate: self.atlDate,
            lastUpdated: self.lastUpdated,
            sparklineIn7D: self.sparklineIn7D,
            priceChangePercentage24HInCurrency: self.priceChangePercentage24HInCurrency,
            currentHoldings: currentHoldings ?? self.currentHoldings
        )
    }

    // 3. YOUR UPDATE FUNCTION
    func updateCurrentHoldings(_ value: Double) -> CoinPresentationModel {
        return self.copy(currentHoldings: value)
    }
    
}


