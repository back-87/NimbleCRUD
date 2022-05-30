//
//  SwiftUIView.swift
//  
//
//  Created by Braden Ackerman on 2022-06-01.
//

import SwiftUI
import NumericText

struct EditViewNumber: View {
    
    enum NumericCoreDataType {
        case floatAttributeType
        case doubleAttributeType
        case decimalAttributeType
        case integer64AttributeType
        case integer32AttributeType
        case integer16AttributeType
    }
    
    var decimalFormatterMaintainingDecimalDigits  = { (number : NSNumber) -> NumberFormatter in

        let formatter = NumberFormatter()

        if let decSeperator = Locale.current.decimalSeparator {
            formatter.minimumFractionDigits = number.doubleValue.exponent == 1 ? 1 : 0
            formatter.maximumFractionDigits = (number.stringValue.components(separatedBy: decSeperator).last)!.count
        }
        
        formatter.numberStyle = .none
        formatter.groupingSize = 0
        formatter.roundingMode = .down
        formatter.minimumIntegerDigits = 1
        
        return formatter
    }

    
    @State private var intValue: NSNumber?
    @State private var validIntValue: NSNumber?
    @State private var intString = "0"
    @State private var doubleValue: NSNumber?
    @State private var validDoubleValue: NSNumber?
    @State private var doubleString = "0.0"
    
    @State var inputType : NumericCoreDataType
    @ObservedObject var viewModel : ViewModel
    
    @State var typeMismatchAlertShown : Bool = false
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                if inputType == .integer16AttributeType ||
                   inputType == .integer32AttributeType ||
                    inputType == .integer64AttributeType {
                    
                    TextField("", text: $intString).numericText(text: $intString, number: $intValue, isDecimalAllowed: false, isNegativeAllowed: true, numberFormatter: nil)
                        .multilineTextAlignment(.center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black)
                        )
                        .padding(.leading)
                        .padding(.trailing)
                        .keyboardType(.numbersAndPunctuation)
                        .onChange(of: intValue) { newValue in
                        
                            if let unwrappedIntValue = intValue {
                            
                                switch(inputType) {
                                    case .integer16AttributeType:
                                
                                        if Int16(intString) != nil || intString == "" || intString == "0" {
                                            viewModel.temporaryEditedNumberValue = unwrappedIntValue
                                            validIntValue = unwrappedIntValue
                                        } else {
                                            typeMismatchAlertShown.toggle() //tell the user they messed up, force reversion after ack
                                        }
                                    
                                    case .integer32AttributeType:
                                        
                                        if Int32(intString) != nil || intString == "" || intString == "0"  {
                                            viewModel.temporaryEditedNumberValue = unwrappedIntValue
                                            validIntValue = unwrappedIntValue
                                        } else {
                                            typeMismatchAlertShown.toggle() //tell the user they messed up, force reversion after ack
                                        }
                                     
                                    case .integer64AttributeType:
                                
                                        if Int64(intString) != nil || intString == "" || intString == "0"  {
                                            viewModel.temporaryEditedNumberValue = unwrappedIntValue
                                            validIntValue = unwrappedIntValue
                                        } else {
                                            typeMismatchAlertShown.toggle() //tell the user they messed up, force reversion after ack
                                        }
                                        

                                    case .doubleAttributeType:
                                        fallthrough
                                    case .floatAttributeType:
                                        fallthrough
                                    case .decimalAttributeType:
                                        logger.error("Checking floating point type for int field, this really shouldn't happen")
                                        fatalError("Checking floating point type for int field, this really shouldn't happen")
                                }
                            }
                            else if(intString == "") {
                                
                                logger.debug("blank, nop")
                                
                              
                            } else if(intString == "-") {
                                logger.debug("dash negative, nop")
                            }
                            else {
                                //nil intValue (user deleted all characters, valid, assume 0)
                                intValue = 0
                                intString = "0"
                                validIntValue = 0
                                viewModel.temporaryEditedNumberValue = 0
                            }
                            }
                            .alert(isPresented: $typeMismatchAlertShown) {
                                Alert(title: Text("Type Mistmatch"),
                                      message: Text("The entered value doesn't fit for this field's type"),
                                      dismissButton: Alert.Button.default(
                                          Text("Back to last valid value"), action: {
                                              intValue = validIntValue //go back to the last valid (for the type) value
                                              intString = validIntValue!.stringValue
                                          }
                                      )
                                )
                              }
                } else {

                    TextField("", text: $doubleString) .numericText(text: $doubleString, number: $doubleValue, isDecimalAllowed: true, isNegativeAllowed: true, numberFormatter: nil)
                        .multilineTextAlignment(.center)
                        .padding(.leading)
                        .padding(.trailing)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black)
                        )
                        .keyboardType(.numbersAndPunctuation)
                        .onChange(of: doubleValue) { newValue in
                            
                            if let strongDouble = doubleValue {
                                logger.debug("onChange of doubleValue: \(strongDouble.stringValue.description)")
                            } else {
                                logger.debug("onChange of doubleValue: nil")
                            }
                            
                            if let unwrappedDblValue = newValue {
                            
                                switch(inputType) {
                                    case .doubleAttributeType:
                                            
                                        if let dblValue = Double(doubleString) {
                                        
                                            if dblValue == 0.0 || (dblValue < .greatestFiniteMagnitude && dblValue > (-.greatestFiniteMagnitude))  {
                                                viewModel.temporaryEditedNumberValue = unwrappedDblValue
                                                validDoubleValue = unwrappedDblValue
                                                //doubleValue = newValue
                                            } else {
                                                typeMismatchAlertShown.toggle() //tell the user they messed up, force reversion after ack
                                            }
                                        }
                                        else {
                                                typeMismatchAlertShown.toggle()
                                        }
                                     
                                    case .floatAttributeType:
                                        if let dblValue = Float(doubleString) {
                                            if dblValue == 0.0 || (dblValue < .greatestFiniteMagnitude && dblValue > (-.greatestFiniteMagnitude))  {
                                                viewModel.temporaryEditedNumberValue = unwrappedDblValue
                                                validDoubleValue = unwrappedDblValue
                                                //doubleValue = newValue
                                            } else {
                                                typeMismatchAlertShown.toggle() //tell the user they messed up, force reversion after ack
                                            }
                                        }
                                        else {
                                                typeMismatchAlertShown.toggle()
                                        }
                                    case .decimalAttributeType:
                                    
                                    if (Decimal(string: doubleString) != nil) {
                                            viewModel.temporaryEditedNumberValue = unwrappedDblValue
                                            validDoubleValue = unwrappedDblValue
                                            //doubleValue = newValue
                                    }
                                    else {
                                            typeMismatchAlertShown.toggle()
                                    }
                                    
                                    case .integer16AttributeType:
                                        fallthrough
                                    case .integer32AttributeType:
                                        fallthrough
                                    case .integer64AttributeType:
                                        logger.error("Checking int  type for floating point field, this really shouldn't happen")
                                        fatalError("Checking int  type for floating point field, this really shouldn't happen")
                                }
                            }
                            else if(doubleString == "") {
                                
                                logger.debug("blank, nop")
                                
                              
                            } else if(doubleString == "-") {
                                logger.debug("dash negative, nop")
                            }
                            else {
                                //nil intValue (user deleted all characters, valid, assume 0)
                                doubleValue = 0.0
                                doubleString = "0"
                                validDoubleValue = 0.0
                                viewModel.temporaryEditedNumberValue = 0
                            }
                              
                        }
                        .alert(isPresented: $typeMismatchAlertShown) {
                            Alert(title: Text("Type Mistmatch"),
                                  message: Text("The entered value doesn't fit for this field's type"),
                                  dismissButton: Alert.Button.default(
                                      Text("Back to last valid value"), action: {
                                          doubleValue = validDoubleValue //go back to the last valid (for the type) value
                                          doubleString = validDoubleValue!.stringValue
                                      }
                                  )
                            )
                          }
                        }
            
                Spacer()
            }//hstack
            Spacer()
        }//vstack
        .onAppear {
            switch(inputType) {
            case .floatAttributeType:
                let fltVal = (viewModel.selectedFieldForEditing as! FieldFloat).value
                doubleValue =  NSNumber(value:fltVal)
                doubleString = decimalFormatterMaintainingDecimalDigits(doubleValue ?? 0.0).string(from: doubleValue ?? 0.0) ?? "0.0"
            case .doubleAttributeType:
                
                let dbl = (viewModel.selectedFieldForEditing as! FieldDouble).value
                doubleValue = NSNumber(value: dbl)
                doubleString = decimalFormatterMaintainingDecimalDigits(doubleValue ?? 0.0).string(from: doubleValue ?? 0.0) ?? "0.0"
            case .decimalAttributeType:
     
                doubleValue =  NSDecimalNumber(decimal: (viewModel.selectedFieldForEditing as! FieldDecimal).value as Decimal)
                doubleString = doubleValue!.stringValue
             
            case .integer64AttributeType:
                intValue =  NSNumber(value: (viewModel.selectedFieldForEditing as! FieldInt64).value)
                intString = intValue!.stringValue
            case .integer32AttributeType:
                intValue =  NSNumber(value: (viewModel.selectedFieldForEditing as! FieldInt32).value)
                intString = intValue!.stringValue
            case .integer16AttributeType:
                intValue =  NSNumber(value: (viewModel.selectedFieldForEditing as! FieldInt16).value)
                intString = intValue!.stringValue
            }
            
            
        }
        
    }
}

struct EditViewNumber_Previews: PreviewProvider {
    static var previews: some View {
        EditViewNumber(inputType: .doubleAttributeType, viewModel: ViewModel(modelName: "ModelName", entityName: "EntityName"))
    }
}
