//
//  ContentView.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 10/12/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CountableEntity.index, ascending: true)],
        animation: .default)
    private var items: FetchedResults<CountableEntity>
    
    @State private var showOrderSheet = false
    @State private var selectedItem: CountableEntity? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    Button(action: {
                        selectedItem = item
                        showOrderSheet = true
                    }, label: {
                        VStack {
                            Text(item.title ?? "empty")
                                .font(.footnote)
                            
                            switch item {
                            case is CounterEntity:
                                Text("\((item as! CounterEntity).date!, formatter: itemFormatter)")
                                    .font(.largeTitle)
                            case is ClickerEntity:
                                Text("\((item as! ClickerEntity).value)")
                                    .font(.largeTitle)
                            default:
                                EmptyView()
                            }
                        }
                        
                    })
                    .frame(maxWidth: .infinity)
                }
                .onDelete(perform: deleteItems)
                
            }
            .sheet(isPresented: $showOrderSheet) {
                DetailsView(item: $selectedItem)
            }
            .toolbar {
                EditButton()
                
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
            
        }
    }

    private func addItem() {
        withAnimation {
            for _ in 0..<10 {
                switch Bool.random() {
                case true:
                    ClickerEntity.random(context: viewContext)
                
                case false:
                    CounterEntity.random(context: viewContext)
                }
            }
            
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
