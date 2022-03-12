//
//  NimbleCRUDView.swift
//  
//
//  Created by Braden Ackerman on 2022-03-11.
//

import SwiftUI
import ScrollViewProxy
import CoreData //only used in View to pass NSPersistentStore instance to ViewModel and eventually to Model

public struct NimbleCRUDView: View {
    
    @ObservedObject var viewModel : ViewModel
    @State(initialValue: false) var paginationOverlayShown : Bool
    @State private var updateScrollOffsetValuesAction: Bool = false
    
    public init(_ persistentContainer : NSPersistentContainer, entityName: String, attributeNameToSortBy: String) {
        viewModel = ViewModel(persistentContainer, entityName: entityName, attributeNameToSortBy: attributeNameToSortBy)
    }
    
    public init(_ persistentContainer : NSPersistentContainer, entityName: String) {
        viewModel = ViewModel(persistentContainer, entityName: entityName)
    }
 
    public init(modelName : String, entityName: String, attributeNameToSortBy: String) {
        viewModel = ViewModel(modelName: modelName, entityName: entityName, attributeNameToSortBy: attributeNameToSortBy)
    }
    
    public init(modelName : String, entityName: String) {
        viewModel = ViewModel(modelName: modelName, entityName: entityName)
    }
    
    public var body: some View {
        //pagination overlay
        let grossScrollControl = GrossScrollControlOverlayView(overlayShown: $paginationOverlayShown, verticalScrollRatio:$viewModel.verticalScrollRatio, horizontalScrollRatio: $viewModel.horizontalScrollRatio)
            //top menu
            HStack {
                Button(action: {
                    
                    if(paginationOverlayShown == false) {
                        updateScrollOffsetValuesAction.toggle()
                    }
                    paginationOverlayShown.toggle()
                    
                }) {
                    Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.red)
                }
                
                Spacer()
                
                Button(action: {
                  print("RIGHT menu pressed")
                }) {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                }
            }.frame(height:50)
            
        ZStack {
            //CRUD table
            GeometryReader { geometry in
                let _ = viewModel.updateScrollViewSize(geometry.size)
                ScrollView([.horizontal, .vertical]) { scrollProxy in
                
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                           
                            Section(header: TableHeaderView(attributeDetails: viewModel.attributeDisplayDetails)) {
                                    ForEach(0..<viewModel.rowCount, id:\.self) { rowIndex in
                                        viewModel.rowViewForRowIndex(rowIndex:rowIndex, geometryProxy: geometry).fixedSize(horizontal: true, vertical: true)
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity,
                               minHeight: geometry.size.height,
                               alignment: .top)
                        .onChange(of: viewModel.verticalScrollRatio, perform: { value in
                            scrollProxy.setYValueOfContentOffsetAsRatio(yRatio: CGFloat(value))
                        })
                        .onChange(of: viewModel.horizontalScrollRatio, perform: { value in
                            scrollProxy.setXValueOfContentOffsetAsRatio(xRatio: CGFloat(value))
                        })
                        .onChange(of: updateScrollOffsetValuesAction, perform: { value in
                            
                            let contentOffsetTuple = scrollProxy.getContentOffsetAsRatio()
                            viewModel.verticalScrollRatio = Float(contentOffsetTuple.y)
                            viewModel.horizontalScrollRatio = Float(contentOffsetTuple.x)
                            grossScrollControl.verticalScrollRatio = viewModel.verticalScrollRatio
                            grossScrollControl.horizontalScrollRatio = viewModel.horizontalScrollRatio
                            
                        })
                        .onAppear(perform:{
                            scrollProxy.setScrollsToTop(false)
                            //viewModel.updateScrollViewSize(geometry.size)
                        })
                }
            }
            
            grossScrollControl
        
        }
    }
 }

public struct NimbleCRUDView_Previews: PreviewProvider {
    public static var previews: some View {
        NimbleCRUDView(modelName: "NimbleCRUDExample", entityName: "TestEntity")
    }
}
