//
//  Dictionary+Inverted.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation

extension Dictionary where Key: Hashable, Value: Hashable {
    var inverted: Dictionary<Value, Key> {
        self.reduce(into: [:], { $0[$1.value] = $1.key })
    }
}
