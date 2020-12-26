//
//  ContentView.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 10/12/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    enum ActiveSheet: Identifiable {
        case details, creator
        
        var id: Int {
            hashValue
        }
    }
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CountableEntity.createdAt, ascending: true)],
        animation: .default)
    private var items: FetchedResults<CountableEntity>
    
    @State private var presentedSheet: ActiveSheet?
    @State private var selectedItem: CountableEntity = CountableEntity()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 24) {
                    ForEach(items) { item in
                        CountableCardView(item: .constant(item))
                        .onTapGesture {
                            selectedItem = item
                            presentedSheet = .details
                        }
                        .onLongPressGesture {
                            guard let clicker = item as? ClickerEntity else { return }
                            
                            let event = EventEntity(context: viewContext)
                            event.clicker = clicker
                            event.timestamp = Date()
                            
                            clicker.addToEvents(event)
                            clicker.value += 1
                            
                            try! viewContext.save()
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .padding([.all], 16)
            }
            .sheet(item: $presentedSheet) { item in
                switch item {
                case .details: DetailsView(item: $selectedItem)
                case .creator: EditorView()
                }
            }
            .navigationTitle("Countupp")
            .toolbar {
                Button(action: {
                    presentedSheet = .creator
                }, label: {
                    Label("Add Item", systemImage: "plus")
                })
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
