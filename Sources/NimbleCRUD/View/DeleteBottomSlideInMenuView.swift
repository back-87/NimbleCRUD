//
//  DeleteBottomSlideInMenuView.swift
//  
//
//  Created by Braden Ackerman on 2022-05-29.
//

import SwiftUI

struct DeleteBottomSlideInMenuView: View {
    
    
    @ObservedObject var viewModel : ViewModel
    @State var clearDestructiveConfirmPresented : Bool = false
    @State var shakeDueToDeleteImpossible : Bool = false
    @State private var specificError : ModelErrors = ModelErrors.undefinedError
    @State private var isErrorMultiDelete = false
    
    var body: some View {
        
        //back button
        HStack {
            Button(action: {
                
                viewModel.multiDeleteCheckboxesShown.toggle()
                withAnimation {
                    viewModel.openCloseDeleteBottomPanel()
                }
                
            }) {
                Image(systemName: "arrowshape.turn.up.backward.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white)
            }
            .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
            .padding(.leading)
            .padding(.top)
            .padding(.bottom)
        
        Spacer()
            
            //select all button
            
            Button(action: {
                
                viewModel.toggleSelectAll()
                
            }) {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(viewModel.allSelected ? Color.blue : Color.white)
                    
            }
            .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
            .padding(.leading)
            .padding(.trailing)
            .padding(.top)
            .padding(.bottom)
            
            
            Spacer()
        
        //delete button
            Button(action: {
                
                if viewModel.anySelectedForDelete() {
                    clearDestructiveConfirmPresented = true
                } else {
                    shakeDueToDeleteImpossible.toggle()
                }
                
            }) {
                Image(systemName: "trash.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white)
                    
            }
            .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
            .padding(.trailing)
            .padding(.top)
            .padding(.bottom)
            .modifier(ShakeEffect(shakes: shakeDueToDeleteImpossible ? 2 : 0)) //<- here
            .animation(Animation.default.repeatCount(0).speed(1))
            
            
        }.background(Color.black)
        .alert(isPresented: $clearDestructiveConfirmPresented) { () -> Alert in
                        let cancelButton = Alert.Button.default(Text("Cancel")) {
                            logger.debug("cancel button pressed, do nothing")
                        }
                        let confirmButton = Alert.Button.cancel(Text("Confirm")) {
                            
                                do {
                                    try viewModel.actuateMultiSelectDelete()
                                    viewModel.multiDeleteCheckboxesShown.toggle()
                                    withAnimation {
                                        viewModel.openCloseDeleteBottomPanel()
                                    }
                                    //confirmation here
                                } catch ModelErrors.unavailableManagedObject {
                                    self.specificError = .unavailableManagedObject
                                    self.isErrorMultiDelete = true
                                }
                                catch {
                                    self.specificError = .undefinedError
                                    self.isErrorMultiDelete = true
                                }
                        }
            
                        if (viewModel.deletionSelectionStatus.count > 1) {
                            return Alert(title: Text("Confirm delete"), message:
                                            Text("Are you sure you'd like to delete these rows ?"),
                                         primaryButton: cancelButton, secondaryButton: confirmButton)
                        } else {
                            return Alert(title: Text("Confirm delete"), message:
                                            Text("Are you sure you'd like to delete this row ?"),
                                         primaryButton: cancelButton, secondaryButton: confirmButton)
                        }
   
        }
    }
}

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct DeleteBottomSlideInMenuView_Preview: PreviewProvider {
    static var previews: some View {
        
        DeleteBottomSlideInMenuView(viewModel: ViewModel(modelName:"ModelName", entityName: "EntityName"))
        
    }
}
