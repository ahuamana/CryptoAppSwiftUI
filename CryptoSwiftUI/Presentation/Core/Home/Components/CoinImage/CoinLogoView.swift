//
//  CoinLogoView.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: CoinPresentationModel
    var body: some View {
        VStack {
            CoinImageview(coin: coin)
                .frame(width: 48, height: 48)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CoinLogoView(coin: DeveloperPreview.dev.coin.toPresentationModel())
}
