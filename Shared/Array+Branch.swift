//
//  Array+Branch.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 7/8/21.
//

import Foundation

extension Array where Element == Note {
    func makeTree() -> (Branch<Note>, [Note]) {
        let sortedNotes = self.sorted(by: { $0.idComponents.zettelOrdered(with: $1.idComponents) })
        let root = Branch(value: Note(id: "", title: "", contents: ""), children: [:])
        var orphans: [Note] = []
        
        sortedNotes.forEach {
            if root.addChild($0, at: $0.id.indexes) {
                orphans.append($0)
            }
        }
        
        return (root, orphans)
    }
}
