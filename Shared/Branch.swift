//
//  Branch.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation

class Branch<Value> {
    let value: Value
    private(set) var children: [Int: Branch<Value>]
    
    init(value: Value, children: [Int: Branch<Value>]) {
        self.value = value
        self.children = children
    }
    
    func addChild(_ value: Value, at index: [Int]) -> Bool {
        guard let indexBit = index.first else { return false }
        if index.count > 1 {
            if children[indexBit] != nil {
                return children[indexBit]!.addChild(value, at: Array(index.dropFirst()))
            } else {
               return false
            }
        } else {
            children[indexBit] = Branch(value: value, children: [:])
            return true
        }
    }
    
    var treeBit: TreeBit<Value> {
        if children.isEmpty {
            return .leaf(value)
        } else {
            return .branch(value, children.map { $0.value.treeBit })
        }
    }
}

extension Branch: Equatable where Value: Equatable {
    static func ==(lhs: Branch, rhs: Branch) -> Bool {
        return lhs.value == rhs.value && lhs.children == rhs.children
    }
}
