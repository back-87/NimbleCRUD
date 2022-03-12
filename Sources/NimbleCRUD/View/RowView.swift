//
//  NimbleCRUDRowView.swift
//  SwiftPlaySecond
//
//  Created by Braden Ackerman on 2022-03-24.
//

import SwiftUI
import CoreData

protocol  FieldInteractionProtocol {
    
    func fieldDoubleTapped(_ field: Field)
    
    func fieldLongPressed(_ field: Field)
}

struct RowView: View {
    
    var rowIndex : Int
    var content : [Field]
    var visiblityAndInteractionDelegate :  FieldInteractionProtocol?
    var widthOracle : ColumnWidthProctol
    
    var body: some View {
        

    HStack{
            
       
            ForEach(content.indices, id:\.self) { colIndex in
                
                let field = content[colIndex]
                let newScrollID = RowColScrollID(row:rowIndex, col:colIndex)
                
                ZStack{
                    Color.clear
                            .frame(maxWidth: .infinity, maxHeight:  .infinity)
                            .contentShape(Rectangle())
                            .gesture(  TapGesture(count: 2)
                                .onEnded {
                                    if let unwrappedVisAndInteractionDel = visiblityAndInteractionDelegate {
                                        unwrappedVisAndInteractionDel.fieldDoubleTapped(field)
                                    }
                                } )
                            .onLongPressGesture(minimumDuration: 0.1, maximumDistance: CGFloat(max(widthOracle.getColumnWidthForAttributeName(field.attributeName), cellHeight)), perform: {
                                if let unwrappedVisAndInteractionDel = visiblityAndInteractionDelegate {
                                    unwrappedVisAndInteractionDel.fieldLongPressed(field)
                                }
                            })
                            
                 
                    //GeometryReader { geometry in
                    
                    
                    switch (field.type) {
                        
                    case .stringAttributeType:
                        
                        let stringField : FieldString = field as! FieldString
                        
                        Text(stringField.presentInPersistentStore ? stringField.value : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .integer16AttributeType:
                        let intField : FieldInt16 = field as! FieldInt16
                        
                        Text(intField.presentInPersistentStore ? intField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .integer32AttributeType:
                        
                        let intField : FieldInt32 = field as! FieldInt32
                        
                        Text(intField.presentInPersistentStore ? intField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .integer64AttributeType:
                        
                        let intField : FieldInt64 = field as! FieldInt64
                        
                        Text(intField.presentInPersistentStore ? intField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .URIAttributeType:
                        
                        let uriField : FieldURI = field as! FieldURI
                        
                        Text(uriField.presentInPersistentStore ? uriField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .decimalAttributeType:
                        
                        let decField : FieldDecimal = field as! FieldDecimal
                        
                        Text(decField.presentInPersistentStore ? decField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .doubleAttributeType:
                        
                        let dblField : FieldDouble = field as! FieldDouble
                        
                        Text(dblField.presentInPersistentStore ? dblField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .floatAttributeType:
                        
                        let fltField : FieldFloat = field as! FieldFloat
                        
                        Text(fltField.presentInPersistentStore ? fltField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                    
                    case .dateAttributeType:
                        
                        let dateField : FieldDate = field as! FieldDate
                        
                        Text(dateField.presentInPersistentStore ? dateField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .binaryDataAttributeType:
                        
                        let dataField : FieldBinary = field as! FieldBinary
                        
                        Text(dataField.presentInPersistentStore ? dataField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                
                    case .booleanAttributeType:
                        let boolField : FieldBool = field as! FieldBool
                        
                        if(boolField.value == true) {
                            Text(boolField.presentInPersistentStore ? "true" : "--")
                                .lineLimit(1)
                                .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                                .scrollId(newScrollID)
                                .allowsHitTesting(false)
                                .font(.system(size: fontSize))
                        } else {
                            Text(boolField.presentInPersistentStore ? "false" : "--")
                                .lineLimit(1)
                                .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                                .scrollId(newScrollID)
                                .allowsHitTesting(false)
                                .font(.system(size: fontSize))
                        }
                       
                        
                    case .UUIDAttributeType:
                        let uuidField : FieldUUID = field as! FieldUUID
                        
                        Text(uuidField.presentInPersistentStore ? uuidField.value.description : "--")
                            .lineLimit(1)
                            .frame(width: widthOracle.getColumnWidthForAttributeName(field.attributeName), height: CGFloat(cellHeight), alignment: .center)
                            .scrollId(newScrollID)
                            .allowsHitTesting(false)
                            .font(.system(size: fontSize))
                        
                    case .undefinedAttributeType:
                        let _ = print("Hit unhandled case (undefinedAttributeType) for NSAttributeType in RowView")
                        Text("ERROR")
                    case .transformableAttributeType:
                        let _ = print("Hit unhandled case (transformableAttributeType) for NSAttributeType in RowView")
                        Text("ERROR")
                    case .objectIDAttributeType:
                        let _ = print("Hit unhandled case (objectIDAttributeType) for NSAttributeType in RowView")
                        Text("ERROR")
                    @unknown default:
                        let _ = print("Hit unhandled *DEFAULT* case for NSAttributeType in RowView")
                        Text("ERROR")
                    }
                   
                    
                    
                }
            }
         }
      }

}



struct RowView_Previews: PreviewProvider, ColumnWidthProctol {

    static var previews: some View {
        GeometryReader { geometry in
            RowView(rowIndex:1, content: [FieldString(attributeName:"testAttribute" ,managedObjectIDUrl:URL(string:"http://wwww.google.ca")!,value: "some value")], visiblityAndInteractionDelegate:nil, widthOracle: self as! ColumnWidthProctol)
        }
    }
    
    func getColumnWidthForAttributeName(_ attributeName:String) -> CGFloat {
        return defaultCellWidth
    }
}

//temp for debug remove me
extension Color {
    /// Return a random color
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
