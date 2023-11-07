//
//  NotesView.swift
//  NotesApp
//
//  Created by Balaji Venkatesh on 24/10/23.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    var category: String?
    var allCategories: [NoteCategory]
    /// Notes
    @Query private var notes: [Note]
    init(category: String?, allCategories: [NoteCategory]) {
        self.category = category
        self.allCategories = allCategories
        /// Dynamic Filtering
        let predicate = #Predicate<Note> {
            return $0.category?.categoryTitle == category
        }
        
        let favouritePredicate = #Predicate<Note> {
            return $0.isFavourite
        }
        
        let finalPredicate = category == "All Notes" ? nil : (category == "Favourites" ? favouritePredicate : predicate)
        
        _notes = Query(filter: finalPredicate, sort: [], animation: .snappy)
    }
    
    /// View Properties
    @FocusState private var isKeyboardEnabled: Bool
    /// Model Context
    @Environment(\.modelContext) private var context
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = size.width
            /// Dynamic Grid Count Based on the Available Size
            let rowCount = max(Int(width / 250), 1)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: rowCount), spacing: 10) {
                    ForEach(notes) { note in
                        NoteCardView(note: note, isKeyboardEnabled: $isKeyboardEnabled)
                            .contextMenu {
                                Button(note.isFavourite ? "Remove from Favourites" : "Move to Favourites") {
                                    note.isFavourite.toggle()
                                }
                                
                                Menu {
                                    ForEach(allCategories) { category in
                                        Button {
                                            /// Updating Category
                                            note.category = category
                                        } label: {
                                            HStack(spacing: 5) {
                                                if category == note.category {
                                                    Image(systemName: "checkmark")
                                                        .font(.caption)
                                                }
                                                
                                                Text(category.categoryTitle)
                                            }
                                        }
                                    }
                                    
                                    Button("Remove from Categories") {
                                        note.category = nil
                                    }
                                } label: {
                                    Text("Category")
                                }
                                
                                Button("Delete", role: .destructive) {
                                    context.delete(note)
                                }
                            }
                    }
                }
                .padding(12)
            }
            /// Closing TF When Tapped Outside
            .onTapGesture {
                isKeyboardEnabled = false
            }
        }
    }
}

/// Note Card View
/// With Editable TF
struct NoteCardView: View {
    @Bindable var note: Note
    var isKeyboardEnabled: FocusState<Bool>.Binding
    @State private var showNote: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
            
            if showNote {
                TextEditor(text: $note.content)
                    .focused(isKeyboardEnabled)
                    .font(.body)
                    /// Custom Hint
                    .overlay(alignment: .topLeading, content: {
                        Text("Finish Work")
                            .foregroundStyle(.gray)
                            .padding(.leading, 5)
                            .opacity(note.content.isEmpty ? 1 : 0)
                            .allowsHitTesting(false)
                    })
                    .scrollContentBackground(.hidden)
                    .multilineTextAlignment(.leading)
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))
            }
        }
        .onAppear {
            showNote = true
        }
        .onDisappear {
            showNote = false
        }
    }
}

#Preview {
    ContentView()
}
