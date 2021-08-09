//
//  Array+MakeIndexNote.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 7/8/21.
//

import Foundation

extension Array where Element == Note {
    func indexNote(title: String) -> String {
        let smallestIDSize = self.map { $0.idComponents.count }.min() ?? 1
        return "# \(title)\n\n" + self.map { note in
            let tabs = String(repeating: "\t", count: note.id.idComponents.count - smallestIDSize)
            return "\(tabs)- \(note.title) [[\(note.id)]]"
        }.joined(separator: "\n")
    }
}
