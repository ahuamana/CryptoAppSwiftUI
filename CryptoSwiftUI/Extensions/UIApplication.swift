//
//  UIApplication.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
