//
//  Array+ZettelID.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 7/8/21.
//

import Foundation

extension Array where Element == String {
    func zettelOrdered(with other: [String]) -> Bool {
        for index in (0 ..< Swift.min(self.count, other.count)) {
            let lhs = self[index]
            let rhs = other[index]
            
            if let lhsInt = Int(lhs), let rhsInt = Int(rhs), let intOrdered = lhsInt.zettelIDOrdered(with: rhsInt) {
                return intOrdered
            } else if let letterOrdered = lhs.zettelIDOrdered(with: rhs) {
                return letterOrdered
            }
        }
        
        if self.count != other.count {
            return self.count < other.count
        } else {
            return true
        }
    }
}
