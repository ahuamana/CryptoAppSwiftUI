//
//  String.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 26/12/25.
//

import Foundation

extension String {
    var removingHtmlOccurances:String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
