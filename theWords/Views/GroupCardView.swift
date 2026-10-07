//
//  GroupCardView.swift
//  theWords
//
//  Created by mucayid on 2026-02-01.
//

import SwiftUI

struct GroupCardView: View {
    let group: WordGroup

    var body: some View {
        VStack(spacing: 12) {
            Text(group.icon)
                .font(.system(size: 42))

            Text(group.name)
                .font(.headline)
                .foregroundStyle(.primary)

            Text("\(group.words.count) kelime")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(
            Color(hex: group.colorHex).opacity(0.25),
            in: RoundedRectangle(cornerRadius: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: group.colorHex), lineWidth: 1)
        )
    }
}
