//
//  Int+ZettelID.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation

extension Int {
    var letterID: String {
        return self.inBase(26).map { String.letters[$0]! }.joined()
    }
    
    var numberID: String {
        return "\(1 + self)"
    }
}

extension Array where Element == Int {
    var asZettelID: String {
        self.enumerated().map {
            return $0.offset % 2 == 0 ? $0.element.numberID : $0.element.letterID
        }.joined()
    }
}

extension Int {
    func zettelIDOrdered(with other: Int) -> Bool? {
        if self == other {
            return nil
        } else if self < other {
            return true
        } else {
            return false
        }
    }
}
