//
//  ViewModel.swift
//  
//
//  Created by Braden Ackerman on 2022-03-11.
//

import Foundation
import SwiftUI
import CoreData



public let headerHeight = 50
public let cellHeight = 100.0
public let defaultCellWidth  = 150.0 //only used during error state
public let columnWidthPadding = 10.0

public let maxPortionOfScreenWidthPerColumn = 0.66

public var fontSize = 12.0
public var fontSizeColumnHeader = 16.0
public var maxFieldsToRetrieveForColumnWidthDetermination = 100

protocol  ColumnWidthProctol {
    
    func getColumnWidthForAttributeName(_ attributeName:String) -> CGFloat
    
}


class ViewModel :  FieldInteractionProtocol, ObservableObject, ColumnWidthProctol {

    @Published var verticalScrollRatio: Float = 0.0 // 0 being top, 1 being bottomed out
    @Published var horizontalScrollRatio: Float = 0.0 //0 being fully left (0 column leading aligned) and 1 being scroll max right (highest col trailing aligned)
    
    @Published var editSheetShown : Bool = false
    @Published var selectedFieldForEditing : Field?
    
    @Published var paginationOverlayShown : Bool = false
    @Published var updateScrollOffsetValuesAction: Bool = false
    
    private var scrollViewSize : CGSize = CGSize.zero
    
    private var model : Model
    
    var temporaryEditedStringValue : String?
    
    public var attributeDisplayDetails : [AttributeDisplayDetails] {
        return _attributeDisplayDetails
    }
    var _attributeDisplayDetails: [AttributeDisplayDetails] = [AttributeDisplayDetails(name: "uninitialized", width: 150, type: NSAttributeType.stringAttributeType)]
    var attributeDetailsNeedRefresh = true
    
    
    public init(_ persistentContainer : NSPersistentContainer, entityName: String) {
        model = Model(persistentContainer:persistentContainer, entityName: entityName)
    }
    
    public init(_ persistentContainer : NSPersistentContainer, entityName: String, attributeNameToSortBy: String) {
        model = Model(persistentContainer:persistentContainer, entityName: entityName, attributeNameToSortBy: attributeNameToSortBy)
    }

    public init(modelName : String, entityName: String, attributeNameToSortBy: String) {
        model = Model(modelName: modelName, entityName: entityName, attributeNameToSortBy: attributeNameToSortBy)
    }
    
    public init(modelName : String, entityName: String) {
        model = Model(modelName: modelName, entityName: entityName)
    }
    
    public func updateScrollViewSize(_ newSize : CGSize) {
        if scrollViewSize != newSize  {
            scrollViewSize = newSize
            print("Updated scrollViewSize to: \(newSize)")
            refreshColumnWidths()
        }
    }
    
    //currently the only time this needs to be called is when orientation changes
    // ^^ because the product of maxPortionOfScreenWidthPerColumn and screen width changes between portrait vs landscape
    public func refreshColumnWidths() {
        _attributeDisplayDetails = determineColumnWidths()
    }
    
    public func getColumnWidthForAttributeName(_ attributeName:String) -> CGFloat {
        for attribDetail in attributeDisplayDetails {
            if attribDetail.name == attributeName {
                return attribDetail.width
            }
        }
        return defaultCellWidth
    }
    
    private func determineColumnWidths() -> [AttributeDisplayDetails]{
        guard model.dataLoaded else {
            return [AttributeDisplayDetails(name: "Failure", width: defaultCellWidth, type: .undefinedAttributeType)]
        }
        var attribDetails = [AttributeDisplayDetails]()
        let attribInfo =  model.attributeInfo()
    
        //print("DETERMINING COLUMN WIDTHS")
        //2. iterate a good sample of data and check displayed size
        //grab up 100 managed objects. For each object, calculate the displayed width of each value per attribute. Throw away up to the longest 10, then for either the
        //attribute name. use the column width that's the smallest of a) 1/2 screen width b) longest value after throwing away (or attribute name)
        
        //2.a grab up to 100 objects
        
       // need logic in model to return a dictionary of ATTRIBUTENAME: [100 values] ... called "upto"
        let sampleData = model.getSampleDataForEachAttribute(maxFieldsToRetrieveForColumnWidthDetermination)
        
        for (name, fieldArray) in sampleData  {
            
            if name == "objectID"  {
                continue
            }
            
            var longestPerAttribute = -INT_MAX
            
            for field in fieldArray  {
                let width = Int32(getMaxDisplayedWidthForField(field: field))
                if width > longestPerAttribute  {
                    longestPerAttribute = width
                }
            }
            
            //3. ^^These should all be capped at a max of something (maxPortionOfScreenWidthPerColumn)
            longestPerAttribute = min(longestPerAttribute, Int32(scrollViewSize.width * maxPortionOfScreenWidthPerColumn))
            
            //print("LONGEST WIDTH: \(longestPerAttribute) for attribute: \(name)")
            
            attribDetails.append(AttributeDisplayDetails(name:name, width:Double(longestPerAttribute), type:attribInfo[name] ?? .stringAttributeType))
        }
        
        //sort into alpha order by attribute name, so the fields (which are processed in no standard order) also line up once they're sorted by the same (attribute name)
        attribDetails.sort { (lhs: AttributeDisplayDetails, rhs: AttributeDisplayDetails) -> Bool in
            
            return (lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending)
        }
    
        //4 ... This should be recalculated and the entire table relayed out on orientation change as the available screen width changes. See updateScrollViewSize() -> refreshColumnWidths()
        

        return attribDetails
    }
    

    public var rowCount : Int {
        return model.totalRows
    }
    
    
    // calculates the displayed pixel width for both the value and the attributeName (column header title)
    // and returns the largest of the two
    private func getMaxDisplayedWidthForField(field: Field) -> CGFloat {
        
        let attributeNameAttributedString = NSAttributedString(
            string: field.attributeName,
            attributes: (NSDictionary(
                object: UIFont.systemFont(ofSize: fontSizeColumnHeader),
                forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
        
            
        var largestWidth = attributeNameAttributedString.size().width
        
        guard (field.presentInPersistentStore) else {
            return largestWidth
        }
        
        var fieldAttributedString : NSAttributedString?
        
        switch (field.type) {
            
        case .stringAttributeType:
            
            let stringField : FieldString = field as! FieldString
            
            fieldAttributedString = NSAttributedString(
                string: stringField.value,
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .integer16AttributeType:
            
            let intField : FieldInt16 = field as! FieldInt16
            
            fieldAttributedString = NSAttributedString(
                string: "\(intField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .integer32AttributeType:
            
            let intField : FieldInt32 = field as! FieldInt32
            
            fieldAttributedString = NSAttributedString(
                string: "\(intField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .integer64AttributeType:
            
            let intField : FieldInt64 = field as! FieldInt64
            
            fieldAttributedString = NSAttributedString(
                string: "\(intField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
            
        case .URIAttributeType:
            
            let uriField : FieldURI = field as! FieldURI
            
            fieldAttributedString = NSAttributedString(
                string: "\(uriField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .decimalAttributeType:
            
            let decField : FieldDecimal = field as! FieldDecimal
            
            fieldAttributedString = NSAttributedString(
                string: "\(decField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .doubleAttributeType:
            
            let dblField : FieldDouble = field as! FieldDouble
            
            fieldAttributedString = NSAttributedString(
                string: "\(dblField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .floatAttributeType:
            
            let fltField : FieldFloat = field as! FieldFloat
            
            fieldAttributedString = NSAttributedString(
                string: "\(fltField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
        
        case .dateAttributeType:
            
            let dateField : FieldDate = field as! FieldDate
            
            fieldAttributedString = NSAttributedString(
                string: "\(dateField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .binaryDataAttributeType:
            
            let dataField : FieldBinary = field as! FieldBinary

            fieldAttributedString = NSAttributedString(
                string: "\(dataField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
    
        case .booleanAttributeType:
            
            let boolField : FieldBool = field as! FieldBool
            
            fieldAttributedString = NSAttributedString(
                string: "\(boolField.value ? "true" : "false")",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .UUIDAttributeType:
            let uuidField : FieldUUID = field as! FieldUUID
            
            fieldAttributedString = NSAttributedString(
                string: "\(uuidField.value)",
                attributes: (NSDictionary(
                    object: UIFont.systemFont(ofSize: fontSize),
                    forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any]) )
            
        case .undefinedAttributeType:
            let _ = print("Hit unhandled case (undefinedAttributeType) for NSAttributeType in RowView")
        case .transformableAttributeType:
            let _ = print("Hit unhandled case (transformableAttributeType) for NSAttributeType in RowView")
        case .objectIDAttributeType:
            let _ = print("Hit unhandled case (objectIDAttributeType) for NSAttributeType in RowView")
        @unknown default:
            let _ = print("Hit unhandled *DEFAULT* case for NSAttributeType in RowView")
        }
        
        
        if let validAttributedString = fieldAttributedString {
            if validAttributedString.size().width > largestWidth  {
                
                if field.attributeName == "sequential"  {
                    print("BRADEN OVER WRITTING SEQUENTIAL TITLE AS: \(validAttributedString.size().width)")
                }
                
                largestWidth = validAttributedString.size().width
            }
        }
        
        
    return largestWidth + columnWidthPadding
        
    }
    
    
    public func rowViewForRowIndex(rowIndex : Int, geometryProxy:GeometryProxy) -> RowView {
        
        var dataForRow = model.dataForRow(rowIndex)
        
        //fields come out of order, sort them so they lign up with the header/column titles
        dataForRow.sort { (lhs: Field, rhs: Field) -> Bool in
            // you can have additional code here
            return (lhs.attributeName.localizedCaseInsensitiveCompare(rhs.attributeName) == .orderedAscending)
        }
        
        
        return RowView(rowIndex:rowIndex, content:dataForRow, visiblityAndInteractionDelegate:self, widthOracle: self)
    }
    
    func saveFieldBeingEdited() throws {
        
        if var strongField = selectedFieldForEditing {
            //first apply temp value to Field object depending on type (not applied when entered in case the use elects to revert
            
            switch(strongField.type)  {
                case .stringAttributeType:
                if let strongTempString = temporaryEditedStringValue {
                    var stringField = selectedFieldForEditing as! FieldString
                    stringField.value = strongTempString
                    strongField = stringField
                    selectedFieldForEditing = stringField
                    temporaryEditedStringValue = ""
                }
                case .integer16AttributeType:
                    print("Place holder int16")
                case .integer32AttributeType:
                    print("Place holder int32")
                case .integer64AttributeType:
                    print("Place holder int64")
                case .decimalAttributeType:
                    print("Place holder decimal")
                case .doubleAttributeType:
                    print("Place holder double")
                case .floatAttributeType:
                    print("Place holder float")
                case .booleanAttributeType:
                    print("Place holder boolean")
                case .dateAttributeType:
                    print("Place holder date")
                case .binaryDataAttributeType:
                    print("Place holder binary")
                case .UUIDAttributeType:
                    print("Place holder uuid")
                case .URIAttributeType:
                    print("Place holder uri")
                case .transformableAttributeType:
                    print("Place holder transformable?")
                case .objectIDAttributeType:
                    print("Place holder object")
                case .undefinedAttributeType:
                    fatalError("Tried to open saveFieldBeingEdited with a Field having an .undefined type")
                default:
                    fatalError("Tried to open saveFieldBeingEdited with a Field having an unhandled type")
            }
            
            //send field to model for saving
            do {
                try model.saveField(field: strongField)
            } catch ModelErrors.unavailableManagedObject {
                throw ModelErrors.unavailableManagedObject
            }

        } else {
            logger.warning("Told to saveFieldBeingEdited() but viewModel doesn't know which field is being edited (couldn't unwrap selectedFieldForEditing)")
            throw ModelErrors.editingScratchError
        }

    }
    
    func clearFieldBeingEdited() throws {
        
        if let strongField = selectedFieldForEditing {
            
            do {
                try model.clearField(field: strongField)
            } catch ModelErrors.unavailableManagedObject {
                throw ModelErrors.unavailableManagedObject
            }
        } else {
            logger.warning("Told to clearFieldBeingEdited() but viewModel doesn't know which field is being edited (couldn't unwrap selectedFieldForEditing)")
            throw ModelErrors.editingScratchError
        }
       
    }
    
    func deleteFieldBeingEdited() throws {
        
        if let strongField = selectedFieldForEditing {
            
            do {
                try model.deleteField(field: strongField)
            } catch ModelErrors.unavailableManagedObject {
                throw ModelErrors.unavailableManagedObject
            }
        } else {
            logger.warning("Told to clearFieldBeingEdited() but viewModel doesn't know which field is being edited (couldn't unwrap selectedFieldForEditing)")
            throw ModelErrors.editingScratchError
        }
       
    }

    func closeEdit() {        
        editSheetShown = false
    }
    
    @ViewBuilder
    func getEditDetailViewForFieldBeingEdited() -> some View {
        //actual editing mechanisms in dedicated files
        switch(selectedFieldForEditing?.type)  {
            case .stringAttributeType:
                EditViewString(viewModel: self)
            case .integer16AttributeType:
                Text("Place holder int16")
            case .integer32AttributeType:
                Text("Place holder int32")
            case .integer64AttributeType:
                Text("Place holder int64")
            case .decimalAttributeType:
                Text("Place holder decimal")
            case .doubleAttributeType:
                Text("Place holder double")
            case .floatAttributeType:
                Text("Place holder float")
            case .booleanAttributeType:
                Text("Place holder boolean")
            case .dateAttributeType:
                Text("Place holder date")
            case .binaryDataAttributeType:
                Text("Place holder binary")
            case .UUIDAttributeType:
                Text("Place holder uuid")
            case .URIAttributeType:
                Text("Place holder uri")
            case .transformableAttributeType:
                Text("Place holder transformable?")
            case .objectIDAttributeType:
                Text("Place holder object")
            case .undefinedAttributeType:
                fatalError("Tried to open EditContainer with a Field having an .undefined type")
            default:
                fatalError("Tried to open EditContainer with a Field having an unhandled type")
        }
    }
    
    
// #mark --  FieldInteractionProtocol
    
    func fieldDoubleTapped(_ field: Field) {
        print("DOUBLE TAPPED field: \(field.attributeName) which has type: \(field.type)")
        
        
        
        selectedFieldForEditing = field
        editSheetShown = true
    }
    
    func fieldLongPressed(_ field: Field) {
        print("cell LONG PRESSED field: \(field.attributeName)")
        print("in the future, a context menu will open for said cell (edit, clear, the notes have a list of actions)")
    }
    

}


struct AttributeDisplayDetails : Hashable {
    var name: String
    var width: Double
    var type: NSAttributeType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
    }
}

struct RowColScrollID : Hashable {
    var row : Int
    var col : Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }
}

struct editedValue  {
    let integer16Value : Int16
    let integer32Value : Int32
    let integer64Value : Int64
    let decimalValue : NSDecimalNumber
    let doubleValue : Double
    let floatValue : Float
    let stringValue : String
    let booleanValue : Bool
    let dateValue : Date
    let binaryValue : Data
    let uuidValue : UUID
    let uriValue : URL
}

