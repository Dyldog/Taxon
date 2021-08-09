//
//  main.swift
//  TaxonCL
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation
import ArgumentParser

struct TaxonCL: ParsableCommand {
    static let configuration = CommandConfiguration(
            abstract: "Zettel hierarchy utilities.",
        subcommands: [MakeIndex.self, SwapLinks.self, MoveLinks.self])
}

extension TaxonCL {
    struct MakeIndex: ParsableCommand {
        static let configuration = CommandConfiguration(
                    abstract: "Make index files for notes")
        @Option() var startNote: String?
        @Option() var title: String
        @Option() var noteFolder: String
        @Option() var outputFileTitle: String?
        
        private func sanitiseTitle(_ title: String) -> String {
            return title.lowercased().components(separatedBy: .whitespaces).joined(separator: "-").components(separatedBy: CharacterSet.alphanumerics.union(.init(charactersIn: "-")).inverted).joined()
        }
        
        func run() {
            var notes = Zettelkasten.getNotes(at: URL(string: noteFolder)!)
            
            if let startNote = startNote {
                notes = notes.filter { $0.id.isChildID(of: startNote) }
            }
            
            let noteContents = notes.indexNote(title: title)
            
            let sanitisedTitle = sanitiseTitle(outputFileTitle ?? title) + ".md"
            let outURL = URL(fileURLWithPath: noteFolder).appendingPathComponent(sanitisedTitle, isDirectory: false)
            try! noteContents.write(to: outURL, atomically: true, encoding: .utf8)
        }
    }
}

extension TaxonCL {
    struct SwapLinks: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Switch references for two links")
        
        @Argument var tagA: String
        @Argument var tagB: String
        @Argument var folder: String
        
        var folderURL: URL! { URL(fileURLWithPath: folder) }
        
        func run() {
            var notes = Zettelkasten.getNotes(at: folderURL)
            notes.swapTags(tagA, tagB)
            notes.forEach {
                try! $0.write(to: folderURL)
            }
        }
    }
    
    struct MoveLinks: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Move a link and (optionally) its children")
        
        @Option var tag: String
        @Option var destination: String
        @Flag var asChild: Bool = false
        @Option var folder: String
        var folderURL: URL! { URL(fileURLWithPath: folder) }
        
        func run() {
            var notes = Zettelkasten.getNotes(at: folderURL)
            notes.moveTag(tag, to: destination, asChild: asChild)
            notes.forEach {
                try! $0.write(to: folderURL)
            }
        }
    }
}

TaxonCL.main()
