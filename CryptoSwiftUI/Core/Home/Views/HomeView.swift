//
//  HomeView.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 23/12/25.
//

import Foundation

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio:Bool = false // animate right
    @State private var showPortfolioView:Bool = false // new sheet
    
    var body: some View {
        ZStack {
            //Background layer
            Color.theme.background
            .ignoresSafeArea(edges: .all)
            .sheet(isPresented: $showPortfolioView) {
                PorfolioView()
                    .environmentObject(vm)
            }
            
            //Content layer
            VStack {
                homeHeader
                
                //Title columns
                HomeStatsView(showPortfolio: $showPortfolio)
                
                //SearchBar
                SearchBarView(searchText: $vm.searchText)
                
                ColumnTitles(showPortfolio: $showPortfolio)
                    .environmentObject(vm)
                
                if !showPortfolio {
                    AllCoinsList()
                    .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    PorfolioCoinsList()
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}


#Preview {
    HomeView()
        .navigationBarHidden(true)
        .environmentObject(DeveloperPreview.dev.homeVM)
}

struct AllCoinsList : View {
    @EnvironmentObject private var vm : HomeViewModel
    var body : some View {
        List(vm.allCoins) { coin in
            CoinRowView(coin: coin, showHoldingsColum: false)
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
        }
        .listStyle(PlainListStyle())
    }
}

struct PorfolioCoinsList : View {
    @EnvironmentObject private var vm : HomeViewModel
    var body : some View {
        List(vm.portfolioCoins) { coin in
            CoinRowView(coin: coin, showHoldingsColum: false)
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
        }
        .listStyle(PlainListStyle())
    }
}

struct ColumnTitles : View {
    
    @Binding var showPortfolio: Bool
    @EnvironmentObject private var vm: HomeViewModel

    
    var body: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            
        }.font(.caption)
            .foregroundColor(.theme.secondaryText)
            .padding(.horizontal)
    }
}


extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(nil, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        print("Clicked on plus")
                        showPortfolioView.toggle()
                    }
                }
                .background (CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(nil, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(.degrees(showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
}
