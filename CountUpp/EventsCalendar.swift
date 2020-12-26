//
//  EventsCalendar.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 24/12/2020.
//

import SwiftUI

struct EventsCalendar: View {
    
    @State var monthDate = Date()
    @State var days: Array<Date> = {
        let calendar = Calendar.current
        
        guard
            let start = calendar.date(from: calendar.dateComponents([.month, .year], from: Date())),
            let count = calendar.range(of: .day, in: .month, for: Date()) else { return [] }
        return count.compactMap { index in calendar.date(byAdding: .day, value: index-1, to: start) }
    }()
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
            
            GeometryReader { gr in
                
                let itemSize = gr.size.width / 7
                let columns = Array(repeating: GridItem(.fixed(itemSize), spacing: 0), count: 7)
                
                LazyVGrid(columns: columns,
                          alignment: .center,
                          spacing: 0) {
                    ForEach(days, id: \.self) { day in
                        
                        Text("\(Calendar.current.dateComponents([.day], from: day).day!)")
                            .frame(maxWidth: .infinity, minHeight: itemSize)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct EventsCalendar_Previews: PreviewProvider {
    static var previews: some View {
        EventsCalendar()
    }
}
