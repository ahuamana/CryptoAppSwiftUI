//
//  CoinDetailPresentationModel.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 26/12/25.
//

import Foundation

struct CoinDetailPresentationModel {
    let id, symbol, name : String
    let blockTimeInMinutes: Int
    let hashingAlgorithm: String
    let categories: [String]
    let description: DescriptionDetailPresentationModel
    let links: LinksDetailPresentationModel
}

// MARK: - Description
struct DescriptionDetailPresentationModel: Codable {
    let en: String?
}

struct LinksDetailPresentationModel: Codable {
    let homepage: [String]
    let subredditURL: String
}
