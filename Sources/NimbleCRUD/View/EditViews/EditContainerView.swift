//
//  SwiftUIView.swift
//  
//
//  Created by Braden Ackerman on 2022-05-28.
//

import SwiftUI

struct EditContainerView: View {
    
    @ObservedObject var viewModel : ViewModel

    @State private var isErrorSave = false
    @State private var isErrorClear = false
    @State private var clearDestructiveConfirmPresented = false
    @State private var deleteDestructiveConfirmPresented = false
    @State private var specificError : ModelErrors = ModelErrors.undefinedError
    
    var body: some View {
        
        //setup common views for all data types (ie X to close sheet, save button, clear button, etc)
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        //add xmark.circle SF Symbol to close
                        Button(action: {
                            viewModel.closeEdit()
                        }) {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.black)
                                .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }.padding(10)
                  
                
                HStack {
                    Spacer()
                    Text(viewModel.selectedFieldForEditing?.attributeName ?? "Field name unavailable")
                    Spacer()
                }
                
                viewModel.getEditDetailViewForFieldBeingEdited()
                
                
                //context buttons (save, clear, cancel, etc)
                HStack {
                    Button(action: {
                        clearDestructiveConfirmPresented = true
                    }) {
                        Image(systemName: "pencil.slash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
                    }
                    .padding(.leading)
                    .alert(isPresented: $isErrorClear) {
                        switch(specificError) {
                            case .unavailableManagedObject:
                                return Alert(title: Text("Couldn't find managed object"),
                                      message: Text("Couldn't retrieve managed object via ID URI in order to save. Changes not saved."),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                            case .editingScratchError:
                                return Alert(title: Text("Editing Scratch Error"),
                                      message: Text("Told to clearFieldBeingEdited() but viewModel doesn't know which field is being edited (couldn't unwrap selectedFieldForEditing)"),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                            default:
                                return Alert(title: Text("Undefined error"),
                                      message: Text("Encountered an unknown error trying to save. Changes not saved."),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                        }
                   }
                    .alert(isPresented: $clearDestructiveConfirmPresented) { () -> Alert in
                                let cancelButton = Alert.Button.default(Text("Cancel")) {
                                    logger.debug("cancel button pressed, nop")
                                }
                                let confirmButton = Alert.Button.cancel(Text("Confirm")) {
                                    do {
                                          try viewModel.clearFieldBeingEdited()
                                            viewModel.closeEdit()
                                            //confirmation here
                                        } catch ModelErrors.unavailableManagedObject {
                                            self.specificError = .unavailableManagedObject
                                            self.isErrorClear = true
                                        }
                                        catch ModelErrors.editingScratchError {
                                            self.specificError = .editingScratchError
                                            self.isErrorClear = true
                                        }
                                        catch {
                                            self.specificError = .undefinedError
                                            self.isErrorClear = true
                                        }
                                }
                                return Alert(title: Text("Confirm clear"), message:
                                                Text("Are you sure you'd like to clear this field?"),
                                             primaryButton: cancelButton, secondaryButton: confirmButton)
                            }
                    
                
                    Spacer()
                    
                    
                    Button(action: {
                        deleteDestructiveConfirmPresented = true
                    }) {
                        Image(systemName: "trash.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
                    }
                    .padding(.leading)
                    .alert(isPresented: $isErrorClear) {
                        switch(specificError) {
                            case .unavailableManagedObject:
                                return Alert(title: Text("Couldn't find managed object"),
                                      message: Text("Couldn't retrieve managed object via ID URI in order to save. Changes not saved."),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                            case .editingScratchError:
                                return Alert(title: Text("Editing Scratch Error"),
                                      message: Text("Told to clearFieldBeingEdited() but viewModel doesn't know which field is being edited (couldn't unwrap selectedFieldForEditing)"),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                            default:
                                return Alert(title: Text("Undefined error"),
                                      message: Text("Encountered an unknown error trying to save. Changes not saved."),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                        }
                   }
                    .alert(isPresented: $deleteDestructiveConfirmPresented) { () -> Alert in
                                let cancelButton = Alert.Button.default(Text("Cancel")) {
                                    logger.debug("cancel button pressed, nop")
                                }
                                let confirmButton = Alert.Button.cancel(Text("Confirm")) {
    
                                    do {
                                          try viewModel.deleteFieldBeingEdited()
                                            viewModel.closeEdit()
                                            //confirmation here
                                        } catch ModelErrors.unavailableManagedObject {
                                            self.specificError = .unavailableManagedObject
                                            self.isErrorClear = true
                                        }
                                        catch ModelErrors.editingScratchError {
                                            self.specificError = .editingScratchError
                                            self.isErrorClear = true
                                        }
                                        catch {
                                            self.specificError = .undefinedError
                                            self.isErrorClear = true
                                        }
                                }
                                return Alert(title: Text("Confirm delete field"), message:
                                                Text("Are you sure you'd like to delete this field?"),
                                             primaryButton: cancelButton, secondaryButton: confirmButton)
                            }
                    
                    Spacer()
                    
                    Button(action: {
                        do {
                            try viewModel.saveFieldBeingEdited()
                            viewModel.closeEdit()
                        } catch ModelErrors.unavailableManagedObject {
                            self.specificError = .unavailableManagedObject
                            self.isErrorSave = true
                        }
                        catch ModelErrors.editingScratchError {
                            self.specificError = .editingScratchError
                            self.isErrorSave = true
                        }
                        catch ModelErrors.invalidInputForDataTypeError {
                            self.specificError = .invalidInputForDataTypeError
                            self.isErrorSave = true
                        }
                        catch {
                            self.specificError = .undefinedError
                            self.isErrorSave = true
                        }
                    }) {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
                    }
                    .padding(.trailing)
                    .alert(isPresented: $isErrorSave) {
                        switch(specificError) {
                            case .unavailableManagedObject:
                                return Alert(title: Text("Couldn't find managed object"),
                                      message: Text("Couldn't retrieve managed object via ID URI in order to save. Changes not saved."),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                            case .editingScratchError:
                                return Alert(title: Text("Editing Scratch Error"),
                                      message: Text("Told to saveFieldBeingEdited() but viewModel doesn't know which field is being edited (couldn't unwrap selectedFieldForEditing). Changes not saved"),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                        case .invalidInputForDataTypeError:
                            return Alert(title: Text("Invalid Input For Type"),
                              message: Text("Told to saveFieldBeingEdited() but the data isn't appropriate for the CoreData type. Changes not saved."),
                                         dismissButton: .default(Text("OK"), action: {
                                            viewModel.closeEdit()
                                        }
                                    ))
                            default:
                                return Alert(title: Text("Undefined error"),
                                      message: Text("Encountered an unknown error trying to save. Changes not saved."),
                                             dismissButton: .default(Text("OK"), action: {
                                                viewModel.closeEdit()
                                            }
                                        ))
                        }
                    }
                }
                
                
            }
    }
}

struct EditContainerView_Previews: PreviewProvider {
    static var previews: some View {
        EditContainerView(viewModel: ViewModel(modelName: "test model name", entityName: "test entity name"))
    }
}
