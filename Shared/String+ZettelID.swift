//
//  String+ZettelID.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation

extension String {
    static var zettelIDPartRegex: NSRegularExpression = try! NSRegularExpression(pattern: "[0-9]+|[a-z]+", options: .caseInsensitive)
    static var zettelIDRegex: NSRegularExpression = try! NSRegularExpression(pattern: "([0-9]+|[a-z]+)+", options: .caseInsensitive)
    static var zettelFileRegex: NSRegularExpression = try! NSRegularExpression(pattern: "^([0-9]+|[a-z]+)+\\.md$", options: .caseInsensitive)
    static let mdHeaderRegex = try! NSRegularExpression(pattern: "^# (.+)$", options: .anchorsMatchLines)
    
    var idComponents: [String] {
        
        return String.zettelIDPartRegex.matches(in: self, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: self.count)).map {
            return (self as NSString).substring(with: $0.range) as String
        }
    }
    
    var lastComponentIsNumber: Bool {
        guard let last = idComponents.last else { fatalError() }
        return Int(last) != nil
    }
    
    func childID(increment: Int) -> String {
        if self.lastComponentIsNumber {
            return self + increment.letterID
        } else {
            return self + increment.numberID
        }
    }
    
    func siblingID(increment: Int) -> String {
        var components = self.idComponents
        guard let last = components.popLast() else { fatalError() }
        let newIndex = last.index + increment
        let newComponent = lastComponentIsNumber ? newIndex.numberID : newIndex.letterID
        return (components + [newComponent]).joined()
    }
    
    func isChildID(of otherID: String) -> Bool {
        self != otherID && self.hasPrefix(otherID)
    }
}

extension String {
    func zettelIDOrdered(with other: String) -> Bool? {
        if self == other {
            return nil
        } else if self < other {
            return true
        } else {
            return false
        }
    }
}

extension String {
    var index: Int {
        if let intValue = Int(self) {
            return intValue
        } else {
            let characters = Array(self).map { String($0) }
            let digits = characters.map { String.letters.inverted[$0]! }
            
            let floatVal = digits.reversed().enumerated().reduce(into: 0.0, {
                $0 = $0 + Float($1.element) * powf(26.0, Float($1.offset))
            })
            
            return Int(floatVal)
        }
    }
    
    var indexes: [Int] {
        return idComponents.map { $0.index }
    }
}
