//
//  Maverick.swift
//  CryptoSwiftUI
//
//  Created by Antony Huaman Alikhan on 25/12/25.
//

import Foundation


func testUsingIfLet() {
    //so if let create a variable and inside this enter if it is true ?
   
    var isLogged : Bool? = true
    
    if let message = isLogged {
        //do something is the variable is not nil
    }
    
    guard let message2 = isLogged else {
        print("")
    }
        
}
