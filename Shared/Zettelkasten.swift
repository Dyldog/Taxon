//
//  Zettelkasten.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 7/8/21.
//

import Foundation

enum Zettelkasten {
    static func getNotes(at url: URL) -> [Note] {
        let allNotes = try! FileManager().contentsOfDirectory(atPath: url.path)
        let zettelNotes = allNotes.filter { String.zettelFileRegex.firstMatch(in: $0, options: .anchored, range: NSRange(location: 0, length: $0.count)) != nil }
        let zettelIDs: [Note] = zettelNotes.map { path in
            let id = String.zettelIDPartRegex.matches(in: path, options: .anchored, range: NSRange(location: 0, length: path.count)).map { match in
                (path as NSString).substring(with: match.range)
            }.joined()
            
            let contents = String(data: FileManager().contents(atPath: url.appendingPathComponent(path).path)!, encoding: .utf8)!
            var title: String = ""
            if let titleRange = String.mdHeaderRegex.firstMatch(in: contents, options: [], range: NSRange(location: 0, length: contents.count))?.range(at: 1) {
                title = (contents as NSString).substring(with: titleRange)
            }
            
            return Note(id: id, title: title, contents: contents)
        }
        
        return zettelIDs.sorted(by: { $0.id.idComponents.zettelOrdered(with: $1.id.idComponents) })
    }
}
