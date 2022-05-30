//
//  TableHeaderView.swift
//
//
//  Created by Braden Ackerman on 2022-04-03.
//

import SwiftUI

struct TableHeaderView: View {
    
    var attributeDetails : [AttributeDisplayDetails]
    var viewModel : ViewModel
    
    var body: some View {
        HStack{
            if viewModel.multiDeleteCheckboxesShown {
                
                Image(systemName: "trash")
                    .resizable()
                    .background(Color.black)
                    .scaledToFill()
                    .foregroundColor(Color.white)
                    .frame(width: cellHeight/4, height: cellHeight/4)
                    .padding(.leading)
                    .padding(.trailing)
                    //.transition(.move(edge: .leading))
                
                Divider().background(Color.white)
            } else {
                Divider().background(Color.white)
            }
            
                
            
                ForEach(attributeDetails, id: \.self) {
                    
                    if $0.name == "testAttribString" {
                        
                        let _ = logger.debug("TableHeaderView displaying a string with width: \($0.width)")
                    }
                    
                    Text("\($0.name)")
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .lineLimit(1)
                        .frame(width: $0.width, height: CGFloat(headerHeight), alignment: .center)
                    
                    Divider().background(Color.white)
                    
                }
        }.background(Color.black)
    }
}
