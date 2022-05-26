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
                        .foregroundColor(Color.black)
                }
                .padding(.trailing)
            }
            .menuStyle(BorderlessButtonMenuStyle())
            .frame(maxWidth: 100.0)
            
        }
    }
    
    var optionsMenuItems: some View {
            Group {
                Button(action: {
                    print("Search pressed")
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }.buttonStyle(PlainButtonStyle())
                Button(action: {
                    print("Sort pressed")
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }.buttonStyle(PlainButtonStyle())
                Button(action: {
                    print("Trash pressed")
                    //UIApplication.shared.windows.first?.windowScene
                    
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
