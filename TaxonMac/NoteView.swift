//
//  NoteView.swift
//  TaxonMac
//
//  Created by Dylan Elliott on 6/8/21.
//

import Foundation
import SwiftUI

struct NoteView: View, Identifiable {
    static let height: CGFloat = 20
    @State var offset: CGSize = .zero
    let note: Note
    var id: String { note.id }
    var indentLevel: Int { note.nestLevel }
    let onMove: (NoteView) -> Void
    let onIndentTapped: (NoteView) -> Void
    let onOutdentTapped: (NoteView) -> Void
    
    @State var isDragging: Bool = false
    
    var body: some View {
        HStack {
            if note.idComponents.count > 1 {
                Button(action: { onIndentTapped(self) }, label: {
                    Text("<").frame(alignment: .trailing)
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                .frame(idealWidth: CGFloat(indentLevel * 30), maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .frame(maxHeight: .infinity)
                .frame(width: CGFloat(indentLevel * 30))
                .background(Color.white.opacity(0.2))
            } else {
                Rectangle().frame(width: CGFloat(indentLevel * 30))
                    .foregroundColor(.clear)
            }
            Text("\(note.id): \(note.title)")
                .frame(maxHeight: .infinity, alignment: .leading)
            Button(action: { onOutdentTapped(self) }, label: {
                Text(">")
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
            .frame(minWidth: CGFloat((indentLevel + 1) * 30), alignment: .leading)
            .background(Color.white.opacity(0.2))
            
            Spacer()
        }
        .frame(height: Self.height)
        .frame(maxWidth: .infinity)
        .offset(offset)
        .background(Color.clear)
        .gesture(DragGesture().onChanged { value in
            offset = value.translation
            onMove(self)
            isDragging = true
        }.onEnded { value in
            isDragging = false
            withAnimation {
                offset = .zero
            }
        })
        .zIndex(isDragging ? 1 : 2)
        .listRowBackground(Color.clear)
    }
}

struct NoteView_Previews: PreviewProvider {
    static func noteView(withID id: String = "1a2", named: String = "Hello World") -> NoteView {
        let note = Note(id: id, title: named, contents: "lorem ipsum")
        return NoteView(note: note, onMove: { _ in }, onIndentTapped: { _ in }, onOutdentTapped: { _ in })
    }
    
    static var previews: some View {
        Group {
            noteView(withID: "1")
            noteView(withID: "1a")
            noteView(withID: "1a2")
            
        }
        .background(Color.blue)
        
        
        
    }
}
