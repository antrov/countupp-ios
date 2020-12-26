//
//  CountableCardView.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 25/12/2020.
//

import SwiftUI

struct CountableCardView: View {
    
    @Binding var item: CountableEntity
    
    var value: String {
        switch item {
        case is CounterEntity: return itemFormatter.string(from: (item as! CounterEntity).date!, to: Date()) ?? ":("
        case is ClickerEntity: return "\((item as! ClickerEntity).value)"
        default: return ""
        }
    }
    
    var body: some View {
        VStack {
            Text(item.title)
                .font(.footnote)
            
            Text(value)
                .font(.title)
        }
        .frame(maxWidth: .infinity)
        .padding([.vertical], 24)
        .background(Color.gray)
        .cornerRadius(10)
    }
}

private let itemFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .brief // or .short or .abbreviated
    formatter.allowedUnits = [.day, .month, .year, .hour]
    return formatter
}()

struct CountableCardView_Previews: PreviewProvider {
    static var previews: some View {
        CountableCardView(item: .constant(ClickerEntity.random(context: PersistenceController.preview.container.viewContext)))
    }
}
