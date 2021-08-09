//
//  Int+InBase.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation

extension Int {
    func stripDigit(base: Int) -> (Int, Int) {
        let digit = self % base
        return (self - digit, digit)
    }
    
    func inBase(_ base: Int) -> [Int] {
        var remaining = self
        var digits: [Int] = []
        
        while remaining > 0 {
            let (newRemaining, stripped) = remaining.stripDigit(base: base)
            remaining = newRemaining
            digits.append(stripped)
        }
        
        return digits
    }
}
