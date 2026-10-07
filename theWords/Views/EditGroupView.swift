//
//  EditGroupView.swift
//  theWords
//
//  Created by mucayid on 2026-02-01.
//

import SwiftUI

struct EditGroupView: View {
    @Environment(\.dismiss) private var dismiss

    let group: WordGroup?
    let onSave: (String, String, String) -> Void

    @State private var name: String
    @State private var icon: String
    @State private var color: Color

    init(group: WordGroup?, onSave: @escaping (String, String, String) -> Void) {
        self.group = group
        self.onSave = onSave
        _name = State(initialValue: group?.name ?? "")
        _icon = State(initialValue: group?.icon ?? "📘")
        _color = State(initialValue: Color(hex: group?.colorHex ?? "#A3C9FF"))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Grup Bilgileri") {
                    TextField("Grup adı", text: $name)
                    TextField("Emoji", text: $icon)
                    ColorPicker("Renk", selection: $color)
                }
            }
            .navigationTitle(group == nil ? "Grup Ekle" : "Grubu Düzenle")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        onSave(name, icon, color.toHex())
                        dismiss()
                    }
                    .disabled(name.isEmpty || icon.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
            }
        }
    }
}
