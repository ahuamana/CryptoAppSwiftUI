//
//  DetailViewModel.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 26/12/25.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var aditionalStatitics: [StatisticModel] = []
    
    private let coinDetailService:CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    @Published var coin: CoinPresentationModel
    
    
    init(coin:CoinPresentationModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                print("Received coin detail data. \(returnedArrays)")
                self?.overviewStatistics = returnedArrays.overview
                self?.aditionalStatitics = returnedArrays.additional
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailPresentationModel?, coinModel: CoinPresentationModel) -> (overview:[StatisticModel], additional: [StatisticModel]) {
        
        
        //MARK: overview array
        let overviewArray: [StatisticModel] = createOverviewArray(coinModel: coinModel)
        
        //MARK: Aditional array
        
        let additionalArray: [StatisticModel] = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
    
        return (overviewArray,additionalArray)
    }
    
    private func createOverviewArray(coinModel:CoinPresentationModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coinModel.marketCapChange24H.formattedWithAbbreviations())
        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume.formattedWithAbbreviations())
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [priceStat, marketCapStat, rankStat, volumeStat]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coinModel:CoinPresentationModel, coinDetailModel: CoinDetailPresentationModel?) -> [StatisticModel] {
        let high = coinModel.high24H.asCurrencyWith6Decimals()
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H.asCurrencyWith6Decimals()
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChangePercentage24H.asCurrencyWith6Decimals()
        let pricePercentage2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentage2)
        
        let marketCapChange = "$" + coinModel.marketCapChangePercentage24H.formattedWithAbbreviations()
        let marketCapPercentageChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24 Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange2)
        
        

        let blockTime = coinDetailModel?.blockTimeInMinutes
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime ?? 0)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
        
        return additionalArray
    }
}

