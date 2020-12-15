//
//  DetailsView.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 14/12/2020.
//

import SwiftUI

struct DetailsView: View {
    
    @Binding var item: CountableEntity?
    
    var body: some View {
        Text(item?.title ?? "")
    }
}
//
//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
////        DetailsView(item: )
//    }
//}
