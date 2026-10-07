//
//  GroupDetailView.swift
//  theWords
//
//  Created by mucayid on 2026-02-01.
//

import SwiftUI
import SwiftData
import Foundation


struct GroupDetailView: View {
    let group: WordGroup
    @Environment(\.modelContext) private var context
    @State private var showingAddWord = false
    @State private var flippedWordID: UUID?
    @State private var expandedWordID: UUID?

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 160), spacing: 12)]

        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                if group.words.isEmpty {
                    VStack(spacing: 24) {
                        Image(systemName: "rectangle.stack.badge.person.crop")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("Bu grupta hiç kelime yok.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Text("Yeni bir kelime eklemek için '+' butonunu kullanın.")
                            .font(.body)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    ForEach(group.words) { word in
                        let isFlipped = flippedWordID == word.id
                        let isExpanded = expandedWordID == word.id

                        FlipCardView(
                            isFlipped: isFlipped,
                            isExpanded: isExpanded
                        ) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(word.word)
                                    .font(.headline)

                                if isExpanded {
                                    Text("Tap to flip")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                        } back: {
                            VStack {
                                Text(word.translation)
                                    .multilineTextAlignment(.center)

                                if isExpanded {
                                    Text("Tap to flip back")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                flippedWordID = (isFlipped ? nil : word.id)
                            }
                        }
                        .onLongPressGesture {
                            withAnimation {
                                expandedWordID = (isExpanded ? nil : word.id)
                            }
                        }
                    }
                }
            }
            .padding(12)
        }
        .onAppear {
            print("GroupDetailView loaded for group: \(group.name), word count: \(group.words.count)")
        }
        .navigationTitle(group.name)
        .toolbar {
            Button {
                showingAddWord = true
            } label: {
                Label("Kelime Ekle", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddWord) {
            AddWordView(group: group)
                .environment(\.modelContext, context)
        }
    }

    private func deleteWords(at offsets: IndexSet) {
        for index in offsets {
            let word = group.words[index]
            context.delete(word)
        }
    }
}

struct AddWordView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let group: WordGroup

    @State private var newWord = ""
    @State private var newTranslation = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Kelime Bilgileri")) {
                    TextField("Kelime", text: $newWord)
                    TextField("Çeviri", text: $newTranslation)
                }
                Section {
                    Button("Kaydet") {
                        let word = Word(word: newWord, translation: newTranslation, group: group)
                        group.words.append(word)
                        context.insert(word)
                        dismiss()
                    }
                    .disabled(newWord.trimmingCharacters(in: .whitespaces).isEmpty || newTranslation.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Kelime Ekle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
            }
        }
    }
}

