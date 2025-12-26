//
//  PorfolioView.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import SwiftUI

struct PorfolioView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @State private var selectedCoin: CoinPresentationModel? = nil
    @State private var quantityText:String = ""
    @State private var showCheckMark:Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil {
                        porfolioInputSection
                    }
                        
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
                
            })
            .onChange(of: vm.searchText, perform: {value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
        
    }
    
    
}

extension PorfolioView {
    private var coinLogoList : some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing:10) {
                ForEach (vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateTheSelectedCoin(coin: coin)
                            }
                        }
                        .background (
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1
                                )
                        )
                        .padding(.vertical, 4)
                        .padding(.leading)
                }
            }
        })
    }
    
    func updateTheSelectedCoin(coin:CoinPresentationModel) {
        self.selectedCoin = coin
        
        if let porfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }) {
            let amount = porfolioCoin.currentHoldings
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
        
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    private var porfolioInputSection : some View {
        VStack(spacing:20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            HStack {
                Text("Amount holding")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(nil, value: true)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity( (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            )
        }
        .font(.headline)
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
                let amount = Double(quantityText)
        else {return }
        
        //save to porfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        //show checkmark
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        })
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
}

#Preview {
    PorfolioView()
        .environmentObject(DeveloperPreview.dev.homeVM)
}
