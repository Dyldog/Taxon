//
//  Note+Links.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 7/8/21.
//

import Foundation

extension Note {
    func noteContainsLink(_ link: String, isIntermediate: Bool = false) -> Bool {
        return self.contents.contains("\(wrapper(forLeftSide: true, isIntermediate: isIntermediate))\(link)\(wrapper(forLeftSide: false, isIntermediate: isIntermediate))")
    }
    
    private func wrapper(forLeftSide leftSide: Bool, isIntermediate: Bool) -> String {
        switch (leftSide, isIntermediate) {
        case (true, false): return "[["
        case (false, false): return "]]"
        case (_, true): return "$$$$$"
        }
    }
    
    mutating func replacingLink(_ oldLink: String, with newLink: String, toIntermediate: Bool = false, fromIntermediate: Bool = false) {
        let searchString = "\(wrapper(forLeftSide: true, isIntermediate: fromIntermediate))\(oldLink)\(wrapper(forLeftSide: false, isIntermediate: fromIntermediate))"
        let replaceString = "\(wrapper(forLeftSide: true, isIntermediate: toIntermediate))\(newLink)\(wrapper(forLeftSide: false, isIntermediate: toIntermediate))"
        contents = contents.replacingOccurrences(of: searchString, with: replaceString)
    }
}
