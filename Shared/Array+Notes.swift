//
//  Array+Notes.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 7/8/21.
//

import Foundation

extension Array where Element == Note {
    mutating func swapTags(_ tagA: String, _ tagB: String) {
        let intermediateTagA = "EFGSFNWI_INTERMEDIATE_TAG_A_SDFSDFHEWVC"
        let intermediateTagB = "EFGSFNWI_INTERMEDIATE_TAG_B_SDFSDFHEWVC"
                
        self.indices.forEach { noteIdx in
            var note = self[noteIdx]
            guard note.noteContainsLink(intermediateTagA, isIntermediate: true) == false,
                  note.noteContainsLink(intermediateTagB, isIntermediate: true) == false else { fatalError() }
            
            var saveNote = false
            
            if note.id == tagA {
                note.id = tagB
                saveNote = true
            } else if note.id == tagB {
                note.id = tagA
                saveNote = true
            }
            
            if note.noteContainsLink(tagA) || note.noteContainsLink(tagB) {
                note.replacingLink(tagA, with: intermediateTagA, toIntermediate: true)
                note.replacingLink(tagB, with: intermediateTagB, toIntermediate: true)
                note.replacingLink(intermediateTagA, with: tagB, fromIntermediate: true)
                note.replacingLink(intermediateTagB, with: tagA, fromIntermediate: true)
                saveNote = true
            }
            
            if saveNote {
                self[noteIdx] = note
            }
        }
    }
    
    func containsLink(_ tag: String) -> Bool {
        return self.first(where: { $0.noteContainsLink(tag, isIntermediate: false) }) != nil
    }
    
    func childIDs(of tag: String) -> [String] {
        self.enumerated().filter { $0.element.id.isChildID(of: tag) }.map { $0.element.id }
    }
    
    mutating func moveChildren(of tag: String, toBeChildrenOf tagB: String) {
        let newTag = tagB
        let tagChildren = childIDs(of: tag)
        
        tagChildren.forEach { childIdx in
            guard let child = self.first(where: { $0.id == childIdx}) else { return }
            let newChildTag = child.id.replacingOccurrences(of: tag, with: newTag)
            if self.containsLink(newChildTag) {
                moveTag(newChildTag, to: newChildTag.siblingID(increment: 1))
            }
        }
    }
    
    func containsChildren(of tag: String) -> Bool {
        return self.first(where: { $0.id != tag && $0.id.hasPrefix(tag) }) != nil
    }
    
    mutating func moveTag(_ tagA: String, to tagB: String, asChild: Bool = false) {
        let newTag = asChild ? tagB.childID(increment: 1) : tagB.siblingID(increment: 1)
        let newNewTag = newTag.siblingID(increment: 1)
        let newNewNewTag = newNewTag.siblingID(increment: 1)
        
        if self.containsLink(newTag) || self.containsChildren(of: newTag) {
            if self.containsLink(newNewTag) || self.containsChildren(of: newNewTag) {
                moveTag(newNewTag, to: newNewNewTag)
                moveChildren(of: newNewTag, toBeChildrenOf: newNewNewTag)
            }
            
            if self.containsLink(newTag) || self.containsChildren(of: newTag) {
                moveTag(newTag, to: newNewTag)
                moveChildren(of: newTag, toBeChildrenOf: newNewTag)
            }
        }
        
        if self.containsChildren(of: tagA) {
            moveChildren(of: tagA, toBeChildrenOf: newTag)
        }
        
        self.swapTags(tagA, newTag)
        
        // A
        //      A1
        // -> Becoming A2
        //      A2 -> becoming A3
        //          A2A ->
        //          A2B -> becoming A2A
    }
}
