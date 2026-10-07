//
//  Word.swift
//  theWords
//
//  Created by mucayid on 2026-02-01.
//

import SwiftData
import Foundation

@Model
class Word {
    var id: UUID = UUID()
    var word: String
    var translation: String
    var group: WordGroup?

    init(word: String, translation: String, group: WordGroup?) {
        self.word = word
        self.translation = translation
        self.group = group
    }
}

