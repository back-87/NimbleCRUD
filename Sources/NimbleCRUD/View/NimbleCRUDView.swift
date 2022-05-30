//
//  NimbleCRUDView.swift
//  
//
//  Created by Braden Ackerman on 2022-03-11.
//

import SwiftUI
import ScrollViewProxy
import CoreData //only used in View to pass NSPersistentStore instance to ViewModel and eventually to Model
import os

let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: NimbleCRUDView.self)
)


let sfSymbolButtonDimension = 50.0

public struct NimbleCRUDView: View {
    
    @ObservedObject var viewModel : ViewModel
    @State var refreshSectionHeader : Bool = false
    
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
        GeometryReader { proxy in
        //pagination overlay
        let grossScrollControl = GrossScrollControlOverlayView(overlayShown: $viewModel.paginationOverlayShown, verticalScrollRatio:$viewModel.verticalScrollRatio, horizontalScrollRatio: $viewModel.horizontalScrollRatio)
            
            //top menu
            ZStack {
                
                VStack{

                    TopMenuView(viewModel: viewModel)
                    .disabled(viewModel.paginationOverlayShown)//don't allow interaction when the pagination overlay is shown (makes tap outside to close work reliably)
                    
                        ScrollView([.horizontal, .vertical]) { scrollProxy in
                        
                                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                                   
                                    //attributeDetails: viewModel.attributeDisplayDetails
                                    Section(header: TableHeaderView(attributeDetails: viewModel.attributeDisplayDetails, viewModel: viewModel).id(refreshSectionHeader)) {
                                        
                                            ForEach(0..<viewModel.rowCount, id:\.self) { rowIndex in
                                                viewModel.rowViewForRowIndex(rowIndex:rowIndex).fixedSize(horizontal: true, vertical: true)
                                                    .id(UUID()) //2 oe 3 bugs from not giving these unique IDs!
                                            }
                                    }
                                    .id(refreshSectionHeader)
                                    .onChange(of: viewModel.refreshTableHeader) { newValue in
                                        refreshSectionHeader.toggle()
                                    }
                                }
                                .frame(maxWidth: .infinity,
                                       minHeight: viewModel.lastScrollViewSize.height,
                                       alignment: .topLeading)
                                .onChange(of: viewModel.verticalScrollRatio, perform: { value in
                                    scrollProxy.setYValueOfContentOffsetAsRatio(yRatio: CGFloat(value))
                                })
                                .onChange(of: viewModel.horizontalScrollRatio, perform: { value in
                                    scrollProxy.setXValueOfContentOffsetAsRatio(xRatio: CGFloat(value))
                                })
                                .onChange(of: viewModel.updateScrollOffsetValuesAction, perform: { value in
                                    let contentOffsetTuple = scrollProxy.getContentOffsetAsRatio()
                                    viewModel.verticalScrollRatio = Float(contentOffsetTuple.y)
                                    viewModel.horizontalScrollRatio = Float(contentOffsetTuple.x)
                                    grossScrollControl.verticalScrollRatio = viewModel.verticalScrollRatio
                                    grossScrollControl.horizontalScrollRatio = viewModel.horizontalScrollRatio
                                })
                                .onAppear {
                                    
                                    //ToDo: fix me, bug: "table" appears scrolled horizontally (x contentOffset is non-zero). Hackish workaround below
                                    let initialOrientation = UIDevice.current.orientation
                                    var newOrientation = UIInterfaceOrientation.landscapeRight.rawValue
                                    if initialOrientation.isPortrait {
                                        newOrientation = UIInterfaceOrientation.landscapeRight.rawValue
                                    } else {
                                        newOrientation = UIInterfaceOrientation.portrait.rawValue
                                    }
                                    UIDevice.current.setValue(newOrientation, forKey: "orientation")
                              
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        scrollProxy.setXValueOfContentOffsetAsRatio(xRatio: 0.0)
                                        refreshSectionHeader.toggle()
                                        UIDevice.current.setValue(initialOrientation.rawValue, forKey: "orientation")
                                    }
                                }
                             
                        }
                        .frame(alignment: .topLeading)
                        .disabled(viewModel.paginationOverlayShown) //don't allow interaction when the pagination overlay is shown (makes "tap outside of modal/overlayed control to close" work reliably)
                    
                }
                VStack {
                    
                    Spacer()
                    
                    if viewModel.deleteBottomMenuShown {
                        DeleteBottomSlideInMenuView(viewModel: viewModel).transition(.move(edge: .bottom))
                    }
                }
                .frame(maxHeight: .infinity)
                .clipped()
                Text("No data.\nConsider adding some with + above")
                .multilineTextAlignment(.center)
                .opacity(viewModel.isEmpty() ? 1 : 0)
                
                
                //pagination overlay
                grossScrollControl
                    .onPreferenceChange(SizePreferenceKey.self) { _ in
                        print("DID GET SizePreferenceKey CHANGE size: \(proxy.size) ")
                            viewModel.lastScrollViewSize = proxy.size
                            viewModel.updateScrollViewSize(proxy.size)
                    }
                    .overlay(
                    Color.clear.preference( key: SizePreferenceKey.self,
                                            value: proxy.size ))
                
                }/*zstack*/
                .sheet(isPresented: $viewModel.editSheetShown) {
                        EditContainerView(viewModel: viewModel)
                }
        }//geometry
    }//body
}



struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

public struct NimbleCRUDView_Previews: PreviewProvider {
    public static var previews: some View {
        NimbleCRUDView(modelName: "NimbleCRUDExample", entityName: "TestEntity")
    }
}
