//
//  DetailView.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 26/12/25.
//

import SwiftUI

struct DetailView: View {
    let coin: CoinPresentationModel
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.dev.coin.toPresentationModel())
}
