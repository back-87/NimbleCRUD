//
//  TableHeaderView.swift
//  
//
//  Created by Braden Ackerman on 2022-04-03.
//

import SwiftUI

struct TableHeaderView: View {
    
    var attributeDetails : [AttributeDisplayDetails]
    
    var body: some View {
        HStack{
            let _ = print("Header view requested!")
    
                ForEach(attributeDetails, id: \.self) {
                    
                    Text("\($0.name)")
                        .background(Color.random)
                        .lineLimit(1)
                        .frame(width: $0.width, height: CGFloat(headerHeight), alignment: .center)
                }.background(Color.random)
        }
    }
}
