//
//  CoinImageView.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import Foundation
import SwiftUI


struct CoinImageview : View {
    @StateObject var vm: CoinImageViewModel
    
    init(coin:CoinPresentationModel) {
        _vm =  StateObject(wrappedValue: CoinImageViewModel(coin:coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.theme.secondaryText)
            }
        }
    }
}


#Preview {
    CoinImageview(coin: DeveloperPreview.dev.coin.toPresentationModel())
}
