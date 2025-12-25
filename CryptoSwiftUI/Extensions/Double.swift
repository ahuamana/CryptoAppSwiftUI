//
//  Double.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 24/12/25.
//

import Foundation
extension Double {
    
    ///Convert a Double into a Currency with 2 decimal places
    ///```
    /// Convert 1234.56 to $1, 234.56
    /// Convert 12.356 to $12.234.56
    /// Convert 0.56 to $0.56
    ///```
    private var currencyFormatter2 : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current // <- Default value
        formatter.currencyCode = "usd" // <-- change currency
        formatter.currencySymbol = "$" // <-- change currency global
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    ///Convert a Double into a Currency as a String with 2 decimal places
    ///```
    /// Convert 1234.56 to $1, 234.56
    /// Convert 12.356 to $12.356
    /// Convert 0.56 to $0.56
    ///```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    ///Convert a Double into a Currency with 2-6 decimal places
    ///```
    /// Convert 1234.56 to $1, 234.56
    /// Convert 12.356 to $12.234.56
    /// Convert 0.56 to $0.56
    ///```
    private var currencyFormatter6 : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current // <- Default value
        formatter.currencyCode = "usd" // <-- change currency
        formatter.currencySymbol = "$" // <-- change currency global
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    ///Convert a Double into a Currency as a String with 2-6 decimal places
    ///```
    /// Convert 1234.56 to $1, 234.56
    /// Convert 12.356 to $12.234.56
    /// Convert 0.56 to $0.56
    ///```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    ///Convert a Double into a String representation
    ///```
    /// Convert 1.56234 to "1.56"
    ///```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    ///Convert a Double into a String representation with percent symbol
    ///```
    /// Convert 1.56234 to "1.56"
    ///```
    func asPercentageString() -> String {
        return asNumberString() + "%"
    }
}
