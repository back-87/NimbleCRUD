//
//  TopMenuView.swift
//  
//
//  Created by Braden Ackerman on 2022-05-29.
//

import SwiftUI

struct TopMenuView: View {
    
    @ObservedObject var viewModel : ViewModel
    
    var body: some View {
    
            HStack {
                Button(action: {
                    
                    if viewModel.paginationOverlayShown == false  {
                        viewModel.updateScrollOffsetValuesAction.toggle()
                    }
                    viewModel.paginationOverlayShown.toggle()
                    
                }) {
                    Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
                        .foregroundColor(Color.red)
                }
                .padding(.leading)
                
                
                Spacer()
                
                Menu {
                    optionsMenuItems
                } label: {
                    Button(action: {}) {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
                            .foregroundColor(Color.black)
                    }
                    .padding(.trailing)
                }
                
            }
    }
    
    var optionsMenuItems: some View {
            Group {
                Button(action: {
                    logger.debug("Search pressed")
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }.buttonStyle(PlainButtonStyle())
                Button(action: {
                    logger.debug("Sort pressed")
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }.buttonStyle(PlainButtonStyle())
                Button(action: {
                    viewModel.updateScrollOffsetValuesAction.toggle()
                                       

                    viewModel.multiDeleteCheckboxesShown.toggle()
                       withAnimation {
                           
                           viewModel.openCloseDeleteBottomPanel()
                           
                       }
                       viewModel.horizontalScrollRatio = 0.00
                    
                    }) {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }.buttonStyle(PlainButtonStyle())
            }
    }
    
}

struct TopMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TopMenuView(viewModel: ViewModel(modelName: "TestModelName", entityName: "TestEntityName"))
    }
}
