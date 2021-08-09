//
//  Note.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 7/8/21.
//

import Foundation

struct Note: Identifiable {
    var id: String
    let title: String
    var contents: String
    
    var idComponents: [String] {
        let regex = try! NSRegularExpression(pattern: "[0-9]+|[a-z]+", options: .caseInsensitive)
        return regex.matches(in: id, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: id.count)).map {
            return (id as NSString).substring(with: $0.range) as String
        }
    }
    var nestLevel: Int {
        return idComponents.count - 1
    }
    
    func write(to folder: URL) throws {
        try self.contents.write(to: folder.appendingPathComponent(id, isDirectory: false).appendingPathExtension("md"), atomically: true, encoding: .utf8)
    }
}
