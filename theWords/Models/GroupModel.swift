//
//  GroupModel.swift
//  theWords
//
//  Created by mucayid on 2026-02-01.
//


import SwiftData

@Model
class WordGroup {
    var name: String
    var icon: String
    var order: Int
    var colorHex: String   // 👈 YENİ

    @Relationship(deleteRule: .cascade)
    var words: [Word] = []

    init(
        name: String,
        icon: String,
        order: Int,
        colorHex: String = "#A3C9FF"
    ) {
        self.name = name
        self.icon = icon
        self.order = order
        self.colorHex = colorHex
    }
}
