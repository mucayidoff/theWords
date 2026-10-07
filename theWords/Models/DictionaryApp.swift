//
//  DictionaryApp.swift
//  theWords
//
//  Created by mucayid on 2026-02-01.
//

import SwiftUI
import SwiftData

@main
struct DictionaryApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [WordGroup.self, Word.self])
    }
}
