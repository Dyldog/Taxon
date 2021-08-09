//
//  ContentView.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 5/8/21.
//

import SwiftUI

struct NoteList: View {
    @State var notes: [Note]
    
    let onSwap: (Note, Note) -> Void
    
    func note(with id: String) -> Note {
        return notes.first(where: { $0.id == id })!
    }
    
    var body: some View {
        List(notes) { note in
            NoteView(note: note, onMove: { noteView in
                let startIndex: Int = notes.firstIndex(where: {$0.id == noteView.note.id })!
                var endIndex: Int?
                let threshold: CGFloat = NoteView.height * 0.8
                if startIndex < (notes.count - 1), noteView.offset.height > threshold {
                    endIndex = startIndex + 1
                } else if startIndex > 0, noteView.offset.height < -threshold {
                    endIndex = startIndex - 1
                }
                
                if let endIndex = endIndex {
                    noteView.offset.height += CGFloat(endIndex - startIndex) * CGFloat(NoteView.height)
                    notes.swapAt(startIndex, endIndex)
                    onSwap(notes[startIndex], notes[endIndex])
                }
            }, onIndentTapped: { view in
                guard view.note.idComponents.count > 1 else { return }
                let index = notes.firstIndex(where: { $0.id == view.note.id })!
                var note = self.note(with: view.note.id)
                note.id = Array(note.idComponents.dropLast(1)).joined()
                notes[index] = note
            }, onOutdentTapped: { _ in
                
            })
        }
    }
}
struct ContentView: View {
    
    let viewModel: ViewModel = .init()
    
    var body: some View {
        NoteList(notes: viewModel.notes, onSwap: { lhs, rhs in
            
        })
        .frame(minWidth: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
