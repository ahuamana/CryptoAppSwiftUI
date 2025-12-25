//
//  CoinModel.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation

//CoinGecko API Info
/*
 --url GET 'https://pro-api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h' \
 --header 'x-cg-pro-api-key: CG-RavWfeuXWAW11uj7PPxxQGU2'

 JSON Response
 
 {
         "id": "bitcoin",
         "symbol": "btc",
         "name": "Bitcoin",
         "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
         "current_price": 87173,
         "market_cap": 1741288358223,
         "market_cap_rank": 1,
         "fully_diluted_valuation": 1741288358223,
         "total_volume": 36864718523,
         "high_24h": 88092,
         "low_24h": 86713,
         "price_change_24h": -619.8052937280736,
         "price_change_percentage_24h": -0.70599,
         "market_cap_change_24h": -11422457330.24707,
         "market_cap_change_percentage_24h": -0.6517,
         "circulating_supply": 19966437.0,
         "total_supply": 19966437.0,
         "max_supply": 21000000.0,
         "ath": 126080,
         "ath_change_percentage": -30.8515,
         "ath_date": "2025-10-06T18:57:42.558Z",
         "atl": 67.81,
         "atl_change_percentage": 128470.47507,
         "atl_date": "2013-07-06T00:00:00.000Z",
         "roi": null,
         "last_updated": "2025-12-24T11:58:01.810Z",
         "sparkline_in_7d": {
             "price": [
                 86752.66970569802
             ]
         },
         "price_change_percentage_24h_in_currency": -0.7059887158114183
     }
 */


struct CoinModel:Identifiable, Codable {
    let id, symbol, name :String?
    let image: String?
    let currentPrice:Double?
    let marketCap, marketCapRank, fullyDilutedValuation:Int?
    let totalVolume, high24H, low24H:Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath:Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage:Double?
    let atlDate:String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings:Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}

extension CoinModel {
    func toPresentationModel() -> CoinPresentationModel {
        return CoinPresentationModel(
            id: id ?? "",
            symbol: symbol ?? "",
            name: name ?? "",
            image: image ?? "",
            currentPrice: currentPrice ?? 0.0,
            marketCap: marketCap ?? 0,
            marketCapRank: marketCapRank ?? 0,
            fullyDilutedValuation: fullyDilutedValuation ?? 0,
            totalVolume: totalVolume ?? 0,
            high24H: high24H ?? 0,
            low24H: low24H ?? 0,
            priceChange24H: priceChange24H ?? 0.0,
            priceChangePercentage24H: priceChangePercentage24H ?? 0.0,
            marketCapChange24H: marketCapChange24H ?? 0,
            marketCapChangePercentage24H: marketCapChangePercentage24H ?? 0.0,
            circulatingSupply: circulatingSupply ?? 0,
            totalSupply: totalSupply ?? 0,
            maxSupply: maxSupply ?? 0,
            ath: ath ?? 0,
            athChangePercentage: athChangePercentage ?? 0.0,
            athDate: athDate ?? "",
            atl: atl ?? 0.0,
            atlChangePercentage: atlChangePercentage ?? 0.0,
            atlDate: atlDate ?? "",
            lastUpdated: lastUpdated ?? "",
            sparklineIn7D: sparklineIn7D?.toPresentationModel() ?? SparklineIn7DPresentationModel(price: []),
            priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency ?? 0.0,
            currentHoldings: currentHoldings ?? 0.0
            )
    }
}


extension SparklineIn7D {
    func toPresentationModel() -> SparklineIn7DPresentationModel {
        return SparklineIn7DPresentationModel(price: price ?? [])
    }
}

