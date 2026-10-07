//
//  Untitled.swift
//  theWords
//
//  Created by mucayid on 2026-02-01.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \WordGroup.order) var groups: [WordGroup]
    @Environment(\.modelContext) private var context
    
    @State private var selectedGroup: WordGroup?
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    @State private var showingAddGroup = false
    
    
    private let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {

                    // Boş durum
                    if groups.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "square.grid.2x2")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)

                            Text("Henüz grup yok")
                                .font(.title3)
                                .foregroundStyle(.secondary)

                            Text("Yeni bir grup eklemek için + butonuna dokun")
                                .font(.body)
                                .foregroundStyle(.tertiary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)

                    } else {
                        ForEach(groups) { group in
                            GroupCardView(group: group)
                                .onTapGesture {
                                    selectedGroup = group
                                }
                                .onLongPressGesture {
                                    selectedGroup = group
                                    showingDeleteAlert = true
                                }
                                .contextMenu {
                                    Button("Düzenle") {
                                        selectedGroup = group
                                        showingEdit = true
                                    }

                                    Button(role: .destructive) {
                                        do {
                                            context.delete(group)
                                            try context.save()
                                        } catch {
                                            print("Save failed after delete: \(error)")
                                        }
                                    } label: {
                                        Label("Sil", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                .padding(16)
            }
            
            
            
            .navigationTitle("Gruplar")
            .toolbar {
                Button {
                    showingAddGroup = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            .navigationDestination(item: $selectedGroup) { group in
                GroupDetailView(group: group)
            }
            .sheet(isPresented: $showingEdit) {
                EditGroupView(group: selectedGroup) { name, icon, colorHex in
                    if let group = selectedGroup {
                        group.name = name
                        group.icon = icon
                        group.colorHex = colorHex
                        do {
                            try context.save()
                        } catch {
                            print("Save failed after edit: \(error)")
                        }
                    }
                }
            }
            .alert("Grup silinsin mi?", isPresented: $showingDeleteAlert) {
                Button("Sil", role: .destructive) {
                    if let group = selectedGroup {
                        do {
                            context.delete(group)
                            try context.save()
                        } catch {
                            print("Save failed after alert delete: \(error)")
                        }
                    }
                }
                Button("İptal", role: .cancel) {}
            }
            .sheet(isPresented: $showingAddGroup) {
                AddGroupView { name, icon, colorHex in
                    let newGroup = WordGroup(
                        name: name,
                        icon: icon,
                        order: groups.count,
                        colorHex: colorHex ?? ""
                    )
                    context.insert(newGroup)
                    
                    do {
                        try context.save()
                    } catch {
                        print("Save failed after add: \(error)")
                    }
                }
            }
        }
        
        
    }

    private func addSampleGroup() {
        let newGroup = WordGroup(
            name: "Meyveler",
            icon: "🍎",
            order: groups.count
        )
        context.insert(newGroup)
        
        do {
            try context.save()
        } catch {
            print("Save failed after sample add: \(error)")
        }
    }
}
struct AddGroupView: View {
    @Environment(\.dismiss) private var dismiss
    var onSave: (_ name: String, _ icon: String, _ colorHex: String?) -> Void

    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var colorHex: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Grup Bilgileri")) {
                    TextField("Ad", text: $name)
                    TextField("İkon (emoji veya SF Symbol)", text: $icon)
                    TextField("Renk (hex, opsiyonel)", text: $colorHex)
                }
                Section {
                    Button("Kaydet") {
                        let colorValue: String? = colorHex.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : colorHex
                        onSave(name, icon, colorValue)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Grup Ekle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
            }
        }
    }
}

