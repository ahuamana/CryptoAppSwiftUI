//
//  CoinRowView.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinPresentationModel
    let showHoldingsColum: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            CoinRowViewLeft(coin: coin)
            Spacer()
            
            if showHoldingsColum {
                CoinRowViewCenter(coin: coin)
            }
            
            CoinRowViewRight(coin: coin)
            
        }
        .font(.subheadline)
    }
}

struct CoinRowViewLeft : View {
    let coin: CoinPresentationModel
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(coin.marketCapRank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(.theme.accent)
        }
    }
}

struct CoinRowViewCenter : View {
    let coin: CoinPresentationModel
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldings.asCurrencyWith2Decimals())
                .bold()
            Text(coin.currentHoldings.asNumberString())
        }
    }
}

struct CoinRowViewRight:View {
    let coin: CoinPresentationModel
    
    var body: some View {
        VStack() {
            Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                .bold()
                .foregroundColor(.theme.accent)
            Text(coin.priceChangePercentage24H.asPercentageString())
                .foregroundColor(
                    coin.priceChangePercentage24H < 0 ? .theme.green : .red
                )
        }.frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CoinRowView(coin: DeveloperPreview.dev.coin.toPresentationModel(), showHoldingsColum: true)
            .preferredColorScheme(.light)
        
        CoinRowView(coin: DeveloperPreview.dev.coin.toPresentationModel(), showHoldingsColum: true)
            .preferredColorScheme(.dark)
            
        
    }
    
}
