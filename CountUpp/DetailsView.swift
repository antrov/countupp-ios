//
//  DetailsView.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 14/12/2020.
//

import SwiftUI

struct DetailsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var item: CountableEntity
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        Text(item.title)
                        Text(item.currentValue)
                    }
                    
                    Section {
//                        switch item {
//                        case is ClickerEntity:
                            EventsCalendar()
                            
//                        case is CounterEntity:
//                            EmptyView()
//                            
//                        default:
//                            EmptyView()
//                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Button(action: {
                    
                }, label: {
                    Text("Delete")
                        .foregroundColor(.red)
                        .padding(.bottom, 32)
                })
            }
            .navigationBarTitle("Details", displayMode: .inline)
        }
    }
}



//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView(item: ClickerEntity.random(context: PersistenceController.preview.container.viewContext))
//    }
//}
