//
//  Tree.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation

enum TreeBit<Value> {
    case branch(Value, [TreeBit])
    case leaf(Value)
    
    func flatten() -> [IndexedElement<Value>] {
        switch self {
        case let .leaf(value):
            return [IndexedElement(value: value, index: [0])]
        case let .branch(value, children):
            let childChildren = children.enumerated().flatMap { enumChildren in
                enumChildren.element.flatten().map { IndexedElement(value: $0.value, index: $0.index + [enumChildren.offset]) }
            }

            return [IndexedElement(value: value, index: [0])] + childChildren
        }
    }
}

extension TreeBit: Equatable where Value: Equatable {
    static func ==(lhs: TreeBit, rhs: TreeBit) -> Bool {
        switch (lhs, rhs) {
        case let (.leaf(lhsValue), .leaf(rhsValue)): return lhsValue == rhsValue
        case let (.branch(lhsValue, lhsChildren), .branch(rhsValue, rhsChildren)): return lhsValue == rhsValue && lhsChildren == rhsChildren
        case (.leaf, _), (.branch, _): return false
        }
    }
}

struct IndexedElement<Value> {
    let value: Value
    let index: [Int]
}

extension IndexedElement: Equatable where Value: Equatable {
    static func ==(lhs: IndexedElement, rhs: IndexedElement) -> Bool {
        return lhs.value == rhs.value && lhs.index == rhs.index
    }
}
