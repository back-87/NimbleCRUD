//
//  ViewModel.swift
//  
//
//  Created by Braden Ackerman on 2022-03-11.
//

import SwiftUI
import CoreData
import Combine


public let headerHeight = 50
public let cellHeight = 100.0
public let defaultCellWidth  = 150.0 //only used during error state
public let columnWidthPadding = 10.0

public let maxPortionOfScreenWidthPerColumn = 0.66

public var fontSize = 12.0
public var fontSizeColumnHeader = 16.0
public var maxFieldsToRetrieveForColumnWidthDetermination = 100


class ViewModel : ObservableObject {
    
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "MMM d YYYY, HH:mm:ss"
        return formatter
    }
    
    //this dictionary is used to identify objects (stored as URLs that can be used to create ManagedObjectIDURIs in the model via the persistentStoreCoordinator) and whether they're "selected" for multi object deletion. The selected state is the value (bool) and the URI is the key. When select all is active, all URIs are added with a true value. When RowView is lazy created via the LazyVStack, it will reference this property to determine how to correctly show the leading "checkbox". After delete is confirmed or the delete bottom panel is closed, this property is reset. This property is also used for the simpler case of single select (user presses the checkboxes individually) - in this case as well the property is reset when the delete panel is closed.
    @Published var deletionSelectionStatus = [URL: Bool]()
    @Published var selectedFieldForEditing : Field?
    @Published var editSheetShown : Bool = false
    @Published var deleteBottomMenuShown : Bool = false
    @Published var multiDeleteCheckboxesShown : Bool = false
    @Published var allSelected : Bool = false
    @Published var refreshTableHeader : Bool = false
    @Published var rowViewRefreshTrigger : Bool = false
    @Published var lastScrollViewSize = CGSize(width: 0.0, height: 0.0)
    
    @Published var verticalScrollRatio: Float = 0.0 // 0 being top, 1 being bottomed out
    @Published var horizontalScrollRatio: Float = 0.0 //0 being fully left (0 column leading aligned) and 1 being scroll max right (highest col trailing aligned
    
    @Published var paginationOverlayShown : Bool = false
    @Published var updateScrollOffsetValuesAction: Bool = false
    
    @Published var selectAllForMultiDeleteActive : Bool = false
    
    private var scrollViewSize : CGSize = CGSize.zero
    
    private var model : Model
    
    var temporaryEditedStringValue : String?
    
    var temporaryEditedBinaryDataValue : Data?
    
    var temporaryEditedNumberValue : NSNumber?
    
    

    var attributeDisplayDetails: [AttributeDisplayDetails] = [AttributeDisplayDetails(name: "uninitialized", width: 150, type: NSAttributeType.stringAttributeType)]
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
            logger.debug("Updated scrollViewSize to: w:\(newSize.width) h:\(newSize.height)")
            refreshColumnWidths()
        } else {
            logger.warning("updateScrollViewSize() with same size")
        }
    }

    //currently the only time this needs to be called is when orientation changes
    // ^^ because the product of maxPortionOfScreenWidthPerColumn and screen width changes between portrait vs landscape
    public func refreshColumnWidths() {
        attributeDisplayDetails = determineColumnWidths()
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
    
        logger.debug("DETERMINING COLUMN WIDTHS")
        //2. iterate a good sample of data and check displayed size
        //grab up 100 managed objects. For each object, calculate the displayed width of each value per attribute. Throw away up to the longest 10, then for either the
        //attribute name. use the column width that's the smallest of a) 1/2 screen width b) longest value after throwing away (or attribute name)
        
        //2.a grab up to 100 objects
        
       // need logic in model to return a dictionary of ATTRIBUTENAME: [100 values] ... called "upto"

        let sampleData = model.getSampleDataForEachAttribute(min(rowCount, maxFieldsToRetrieveForColumnWidthDetermination))
    
    
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
            let _ = logger.error("Hit unhandled case (undefinedAttributeType) for NSAttributeType in RowView")
        case .transformableAttributeType:
            let _ = logger.error("Hit unhandled case (transformableAttributeType) for NSAttributeType in RowView")
        case .objectIDAttributeType:
            let _ = logger.error("Hit unhandled case (objectIDAttributeType) for NSAttributeType in RowView")
        @unknown default:
            let _ = logger.error("Hit unhandled *DEFAULT* case for NSAttributeType in RowView")
        }
        
        
        if let validAttributedString = fieldAttributedString {
            if validAttributedString.size().width > largestWidth  {
                largestWidth = validAttributedString.size().width
            }
        }
        
        
    return largestWidth + columnWidthPadding
        
    }
    
    
    public func rowViewForRowIndex(rowIndex : Int) -> RowView {
        
        var dataForRow = model.dataForRow(rowIndex)
        
        //fields come out of order, sort them so they lign up with the header/column titles
        dataForRow.sort { (lhs: Field, rhs: Field) -> Bool in
            // you can have additional code here
            return (lhs.attributeName.localizedCaseInsensitiveCompare(rhs.attributeName) == .orderedAscending)
        }
        
        
        return RowView(rowIndex:rowIndex, content:dataForRow, viewModel: self)

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
                if let strongTempInt16 = temporaryEditedNumberValue {
                    var int16Field = selectedFieldForEditing as! FieldInt16
                    int16Field.value = strongTempInt16.int16Value
                    strongField = int16Field
                    selectedFieldForEditing = int16Field
                    temporaryEditedNumberValue = NSNumber(0)
                }
                case .integer32AttributeType:
                if let strongTempInt32 = temporaryEditedNumberValue {
                    var int32Field = selectedFieldForEditing as! FieldInt32
                    int32Field.value = strongTempInt32.int32Value
                    strongField = int32Field
                    selectedFieldForEditing = int32Field
                    temporaryEditedNumberValue = NSNumber(0)
                }
                case .integer64AttributeType:
                if let strongTempInt64 = temporaryEditedNumberValue {
                    var int64Field = selectedFieldForEditing as! FieldInt64
                    int64Field.value = strongTempInt64.int64Value
                    strongField = int64Field
                    selectedFieldForEditing = int64Field
                    temporaryEditedNumberValue = NSNumber(0)
                }
                case .decimalAttributeType:
                if let strongTempDec = temporaryEditedNumberValue {
                    var decimalField = selectedFieldForEditing as! FieldDecimal
                    decimalField.value = NSDecimalNumber(decimal: strongTempDec.decimalValue)
                    strongField = decimalField
                    selectedFieldForEditing = decimalField
                    temporaryEditedNumberValue = NSNumber(0)
                }
                case .doubleAttributeType:
                if let strongTempDbl = temporaryEditedNumberValue {
                    var doubleField = selectedFieldForEditing as! FieldDouble
                    doubleField.value = strongTempDbl.doubleValue
                    strongField = doubleField
                    selectedFieldForEditing = doubleField
                    temporaryEditedNumberValue = NSNumber(0)
                }
                case .floatAttributeType:
                if let strongTempFlt = temporaryEditedNumberValue {
                    var floatField = selectedFieldForEditing as! FieldFloat
                    floatField.value = strongTempFlt.floatValue
                    strongField = floatField
                    selectedFieldForEditing = floatField
                    temporaryEditedNumberValue = NSNumber(0)
                }
                case .booleanAttributeType:
                    print("Place holder boolean")
                case .dateAttributeType:
                    print("Place holder date")
                case .binaryDataAttributeType:
                    if let strongData = temporaryEditedBinaryDataValue {
                        var binaryField = selectedFieldForEditing as! FieldBinary
                        binaryField.value = strongData
                        strongField = binaryField
                        selectedFieldForEditing = binaryField
                        temporaryEditedBinaryDataValue = "".data(using: String.Encoding.utf8)
                    }
                case .UUIDAttributeType:
                    print("Place holder uuid")
                case .URIAttributeType:
                    print("Place holder uri")
                case .transformableAttributeType:
                    print("Place holder transformable?")
                case .objectIDAttributeType:
                    print("Place holder object")
                case .undefinedAttributeType:
                    logger.error("Tried to open saveFieldBeingEdited with a Field having an .undefined type")
                    fatalError("Tried to open saveFieldBeingEdited with a Field having an .undefined type")
                default:
                    logger.error("Tried to open saveFieldBeingEdited with a Field having an unhandled type")
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
                EditViewNumber(inputType: .integer16AttributeType, viewModel: self)
            case .integer32AttributeType:
                EditViewNumber(inputType: .integer32AttributeType, viewModel: self)
            case .integer64AttributeType:
                EditViewNumber(inputType: .integer64AttributeType, viewModel: self)
            case .decimalAttributeType:
                EditViewNumber(inputType: .decimalAttributeType, viewModel: self)
            case .doubleAttributeType:
                EditViewNumber(inputType: .doubleAttributeType, viewModel: self)
            case .floatAttributeType:
                EditViewNumber(inputType: .floatAttributeType, viewModel: self)
            case .booleanAttributeType:
                Text("Place holder boolean")
            case .dateAttributeType:
                Text("Place holder date")
            case .binaryDataAttributeType:
                EditViewBinary(viewModel: self)
            case .UUIDAttributeType:
                Text("Place holder uuid")
            case .URIAttributeType:
                Text("Place holder uri")
            case .transformableAttributeType:
                let _ = logger.error("Tried to open EditContainer with a Field having a transformableAttributeType type")
                fatalError("Tried to open EditContainer with a Field having an .transformableAttributeType type")
            case .objectIDAttributeType:
                let _ = logger.error("Tried to open EditContainer with a Field having a objectIDAttributeType type")
                fatalError("Tried to open EditContainer with a Field having an .objectIDAttributeType type")
            case .undefinedAttributeType:
                let _ = logger.error("Tried to open EditContainer with a Field having an .undefined type")
                fatalError("Tried to open EditContainer with a Field having an .undefined type")
            default:
                let _ =  logger.error("Tried to open EditContainer with a Field having an unhandled type")
                fatalError("Tried to open EditContainer with a Field having an unhandled type")
        }
    }
    
    func selectFieldForDelete(_ field : Field) {
        deletionSelectionStatus[field.managedObjectIDUrl] = true
    }
    
    func deSelectFieldForDelete(_ field : Field) {
        deletionSelectionStatus[field.managedObjectIDUrl] = false
    }
    
    //destructive, ensure the user confirms this prior to calling :)
    //iterates all entries in deletionSelectionStatus, where the value is true the model is told to delete that ManagedObject represented by that URL
    func actuateMultiSelectDelete() throws {
        
        var urlList = [URL]()
        
        for (key, value) in deletionSelectionStatus
        {
            if value {
                //send URL to model for deletion
                
                urlList.append(key)
                
            }
        }
        
        model.deleteRows(urlList)
    }
    
    func anySelectedForDelete() -> Bool {
        
        var anySelected : Bool = false
        
        for (_, value) in deletionSelectionStatus
        {
            if value {
                anySelected = true
            }
        }
        
        return anySelected
    }
    
    func isFieldSelectedForDelete(_ field: Field) -> Bool {
        
        var isSelected : Bool = false
        
        for (key, value) in deletionSelectionStatus
        {
            if key == field.managedObjectIDUrl && value {
                isSelected = true
            }
        }
        return isSelected
    }
    
    func openCloseDeleteBottomPanel() {
        deleteBottomMenuShown.toggle()
        
        //clear deletionSelectionStatus
        deletionSelectionStatus = [URL: Bool]()
        allSelected = false
        
        self.refreshTableHeader.toggle()
    }
    
    public func isEmpty() -> Bool {
        return (model.totalRows < 1) ? true : false
    }
    
    func toggleSelectAll() {
        allSelected.toggle()
        
        if allSelected {
            //add all managedObjectURIs to deletionSelectionStatus
            deletionSelectionStatus = model.allManagedObjectURIsForSelectAll()
        } else {
            //clear deletionSelectionStatus
            deletionSelectionStatus = [URL: Bool]()
        }
        
        rowViewRefreshTrigger.toggle()
        
    }
    
    public func verticalRatioValueForOneCellHeight() -> Float {
        return Float(Float(scrollViewSize.height) / Float(cellHeight * Double(rowCount)))
    }
    

// #mark --  FieldInteractionProtocol
    
    func fieldDoubleTapped(_ field: Field) {
        logger.debug("DOUBLE TAPPED field: \(field.attributeName) which has type: \(field.type.rawValue)")
        
        selectedFieldForEditing = field
        editSheetShown = true
    }
    
    func fieldLongPressed(_ field: Field) {
        logger.debug("cell LONG PRESSED field: \(field.attributeName)")
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
