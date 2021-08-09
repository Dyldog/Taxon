//
//  ViewModel.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation

struct ViewModel {
    let notes: [Note]
    
    init() {        
        notes = Zettelkasten.getNotes(at: URL(fileURLWithPath: "/Users/dylanelliott/Documents/Zettlekasten"))
    }
}
