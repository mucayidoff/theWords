//
//  FlipCardView.swift
//  theWords
//
//  Created by mucayid on 2026-02-01.
//

import SwiftUI

struct FlipCardView<Front: View, Back: View>: View {
    let front: Front
    let back: Back
    let isFlipped: Bool
    let isExpanded: Bool

    init(
        isFlipped: Bool,
        isExpanded: Bool,
        @ViewBuilder front: () -> Front,
        @ViewBuilder back: () -> Back
    ) {
        self.isFlipped = isFlipped
        self.isExpanded = isExpanded
        self.front = front()
        self.back = back()
    }

    var body: some View {
        ZStack {
            front
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )

            back
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .padding()
        .frame(height: isExpanded ? 160 : 70)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.2))
        )
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: isFlipped)
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: isExpanded)
    }
}
