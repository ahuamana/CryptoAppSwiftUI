//
//  CryptoSwiftUIApp.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 23/12/25.
//

import SwiftUI

@main
struct CryptoSwiftUIApp: App {
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }.environmentObject(vm)
            }
        }
    }
}
