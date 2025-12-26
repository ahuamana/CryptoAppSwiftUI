//
//  DetailView.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 26/12/25.
//

import SwiftUI



struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    let coin: CoinPresentationModel
    @State var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinPresentationModel) {
        self.coin = coin
        _vm = .init(wrappedValue: .init(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                overviewTitle
                    .padding()
                Divider()
                
               descriptionSection
                    .padding()
                
                overviewGrid
                    .padding()
                
                additionalTitle
                    .padding()
                Divider()
                
                additionalGrid
                    .padding()
                
                websiteSection
                    .padding()
                
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
        
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            content: {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            content: {
                ForEach(vm.aditionalStatitics) { stat in
                    StatisticView(stat: stat)
                }
            
        })
    }
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            CoinImageview(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text(coinDescription.removingHtmlOccurances)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                        .lineLimit(showFullDescription ? nil : 3)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Show Less" : "Show More")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                            
                    })
                    .accentColor(.blue)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            
        }
    }
    
    private var websiteSection : some View {
        VStack(alignment: .leading, spacing: 20) {
            if let website = vm.websiteURL,
               let url = URL(string: website) {
                Link(destination: url, label: {
                    Text("Website")
                        .accentColor(.blue)
                        .font(.headline)
                })
            }
            
            if let redditString = vm.redditURL,
               let redditURL = URL(string: redditString) {
                Link(destination: redditURL, label: {
                    Text("Reddit")
                        .accentColor(.blue)
                        .font(.headline)
                })
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.dev.coin.toPresentationModel())
}
