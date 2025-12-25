//
//  ContentView.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 23/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 40) {
                Text("Accent Color")
                    .foregroundColor(.theme.accent)
                
                Text ("Secondary Text Color")
                    .foregroundColor(.theme.secondaryText)
                
                Text("Red Color")
                    .foregroundColor(.theme.red)
                
                Text("Green Color")
                    .foregroundColor(.theme.green)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
