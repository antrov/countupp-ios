//
//  EditorView.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 25/12/2020.
//

import SwiftUI
import Combine

struct EditorView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State var title: String = ""
    @State var type: CounterEntity.EntityType = .counter
    @State var initial: String = "0"
    @State var date: Date = Date()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Name", text: $title)
                }
                
                Section {
                    Picker(selection: $type, label: Text("What is your favorite color?")) {
                        ForEach(CounterEntity.EntityType.allCases, id: \.self) { t in
                            Text(t.rawValue.capitalized)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if type == .clicker {
                        TextField("Initial value", text: $initial)
                            .keyboardType(.numberPad)
                            .onReceive(Just(initial)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.initial = filtered
                                }
                            }
                    } else if type == .counter {
                        DatePicker(selection: $date, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                            Text("Select a date")
                        }
                    } else {
                        Text("WTF type is this?")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Create new")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if type == .clicker {
                            let entity = ClickerEntity(context: viewContext)
                            
                            entity.id = UUID()
                            entity.index = -1
                            entity.createdAt = Date()
                            entity.title = title
                            entity.initial = Int64(initial) ?? 0
                        } else if type == .counter {
                            let entity = CounterEntity(context: viewContext)
                            
                            entity.id = UUID()
                            entity.index = -1
                            entity.createdAt = Date()
                            entity.title = title
                            entity.date = date
                        }
                        
                        do {
                            try viewContext.save()
                        } catch {
                            
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
