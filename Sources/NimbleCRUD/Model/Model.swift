//
//  NimbleCRUDModel.swift
//
//
//  Created by Braden Ackerman on 2022-03-11.
//

import CoreData


class Model {
    
    var entityName : String
    
    var attributeNameForFetchSorting : String
    
    var persistentContainer : NSPersistentContainer
    
    private var entityDescription : NSEntityDescription?
    
    public var dataLoaded = false
    
    var totalRows : Int = 0

    private var batchController : NSFetchedResultsController<NSFetchRequestResult>?

    
    public init(persistentContainer : NSPersistentContainer, entityName: String, attributeNameToSortBy: String) {
        self.entityName = entityName
        self.persistentContainer = persistentContainer
        self.attributeNameForFetchSorting = attributeNameToSortBy
        //self.request = NSFetchRequest(entityName: self.entityName)
        findAndSetEntity(entityName: entityName)
    }
    
    public init(persistentContainer : NSPersistentContainer, entityName: String) {
        self.entityName = entityName
        self.persistentContainer = persistentContainer
        self.attributeNameForFetchSorting = "objectID"
        //self.request = NSFetchRequest(entityName: self.entityName)
        findAndSetEntity(entityName: entityName)
    }

    
    public init(modelName : String, entityName: String, attributeNameToSortBy: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        self.entityName = entityName
        self.attributeNameForFetchSorting = attributeNameToSortBy
        loadContainer()
        findAndSetEntity(entityName: entityName)
    }
    
    public init(modelName : String, entityName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        self.entityName = entityName
        self.attributeNameForFetchSorting = "objectID"
        
        loadContainer()
        findAndSetEntity(entityName: entityName)
    }
    
    private func loadContainer() {
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
          if let error = error as NSError? {
              logger.error("Failed to load stores: \(error), \(error.userInfo)")
            fatalError("Failed to load stores: \(error), \(error.userInfo)")
          } else {
              logger.info("Loaded NSPersistentContainer (\(self.persistentContainer.name)) successfully.")
          }
        })
        
    }
    
    private func findAndSetEntity(entityName: String) {
        for (name, entityRef) in persistentContainer.managedObjectModel.entitiesByName {
            if name == entityName {
                entityDescription = entityRef
                dataLoaded = true
                break
            }
        }
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            totalRows = try persistentContainer.viewContext.count(for: fetch)
        } catch {
            logger.error("Failed to determine total number of rows to expect")
        }
    }
    
    public func attributeInfo() -> Dictionary<String, NSAttributeType> {
        guard let entityDesc = entityDescription else {
            return ["Failure" : .stringAttributeType]
        }
        var attributeNames = Dictionary<String, NSAttributeType>()
        for (attribName, attrDescription) in entityDesc.attributesByName {
            
            // ToDo: don't use NSAttributeType, it's the only (at time of writing) logic requiring iOS 15
            if #available(iOS 15.0, *) {
                switch(attrDescription.type) {
                    case .string:
                        attributeNames[attribName] = NSAttributeType.stringAttributeType
                    case .integer16:
                        attributeNames[attribName] = NSAttributeType.integer16AttributeType
                    case .integer32:
                        attributeNames[attribName] = NSAttributeType.integer32AttributeType
                    case .integer64:
                        attributeNames[attribName] = NSAttributeType.integer64AttributeType
                    case .decimal:
                        attributeNames[attribName] = NSAttributeType.decimalAttributeType
                    case .double:
                        attributeNames[attribName] = NSAttributeType.doubleAttributeType
                    case .float:
                        attributeNames[attribName] = NSAttributeType.floatAttributeType
                    case .boolean:
                        attributeNames[attribName] = NSAttributeType.booleanAttributeType
                    case .date:
                        attributeNames[attribName] = NSAttributeType.dateAttributeType
                    case .binaryData:
                        attributeNames[attribName] = NSAttributeType.binaryDataAttributeType
                    case .uuid:
                        attributeNames[attribName] = NSAttributeType.UUIDAttributeType
                    case .uri:
                        attributeNames[attribName] = NSAttributeType.URIAttributeType
                    case .transformable:
                        attributeNames[attribName] = NSAttributeType.transformableAttributeType
                    case .objectID:
                        attributeNames[attribName] = NSAttributeType.objectIDAttributeType
                    case .undefined:
                        attributeNames[attribName] = NSAttributeType.undefinedAttributeType
                    default:
                        attributeNames[attribName] = NSAttributeType.undefinedAttributeType
                }
            }
        }
        return attributeNames
    }
    
    public func saveField(field : Field) throws {
        
        //invalid coredata URI for testing error state: x-coredata://995AFD12-E7B9-4E57-8609-CEFA3286329A/TestEntity/p0505
        guard let managedObjectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: field.managedObjectIDUrl)
        else {
            throw ModelErrors.unavailableManagedObject
        }
        
        let managedObject = try? persistentContainer.viewContext.existingObject(with:managedObjectID)
        
            //field.managedObjectIDUrl
        if let confirmedObject = managedObject {
            
            switch(field.type)  {
                case .stringAttributeType:
                    let stringField = field as! FieldString
                    confirmedObject.setValue(stringField.value, forKey: stringField.attributeName)
                case .integer16AttributeType:
                    let int16Field = field as! FieldInt16
                    confirmedObject.setValue(int16Field.value, forKey: int16Field.attributeName)
                case .integer32AttributeType:
                    let int32Field = field as! FieldInt32
                    confirmedObject.setValue(int32Field.value, forKey: int32Field.attributeName)
                case .integer64AttributeType:
                    let int64Field = field as! FieldInt64
                    confirmedObject.setValue(int64Field.value, forKey: int64Field.attributeName)
                case .decimalAttributeType:
                    let decimalField = field as! FieldDecimal
                    confirmedObject.setValue(decimalField.value, forKey: decimalField.attributeName)
                case .doubleAttributeType:
                    let doubleField = field as! FieldDouble
                    confirmedObject.setValue(doubleField.value, forKey: doubleField.attributeName)
                case .floatAttributeType:
                    let floatField = field as! FieldFloat
                    logger.debug("truncation/precision loss check. Saving float value: \(floatField.value)")
                    confirmedObject.setValue(floatField.value, forKey: floatField.attributeName)
                case .booleanAttributeType:
                    print("Place holder boolean")
                case .dateAttributeType:
                    print("Place holder date")
                case .binaryDataAttributeType:
                    let binaryField = field as! FieldBinary
                    confirmedObject.setValue(binaryField.value, forKey: binaryField.attributeName)
                case .UUIDAttributeType:
                    print("Place holder uuid")
                case .URIAttributeType:
                    print("Place holder uri")
                case .transformableAttributeType:
                    print("Place holder transformable?")
                case .objectIDAttributeType:
                    print("Place holder object")
                case .undefinedAttributeType:
                    logger.error("Tried to open EditContainer with a Field having an .undefined type")
                    fatalError("Tried to open EditContainer with a Field having an .undefined type")
                default:
                    logger.error("Tried to open EditContainer with a Field having an unhandled type")
                    fatalError("Tried to open EditContainer with a Field having an unhandled type")
            }
            
            do {
               try persistentContainer.viewContext.save()
                self.batchController = nil //cause batchController to be reinstantiated on next read, so new value(s) are reflected
            } catch {
                print("save failed")
                throw ModelErrors.undefinedError
            }
        
        }


    }
    
    public func deleteRows(_ rows : [URL]) {
        
        for (url) in rows {
            deleteRowRepresentedByManagedObjectIDURL(url: url)
        }

        batchController = nil
        findAndSetEntity(entityName: entityName)
        
        //saveContextAsync()
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            logger.error("deleteRows failed with an undefined error")
            fatalError("deleteRows failed with an undefined error")
        }
         
        
    }
    
    public func deleteRowRepresentedByManagedObjectIDURL(url : URL) {
        
        guard let managedObjectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url)
        else {
            logger.error("encountered ModelErrors.unavailableManagedObject")
            fatalError("encountered ModelErrors.unavailableManagedObject")
        }
        
       let managedObject = try? persistentContainer.viewContext.existingObject(with:managedObjectID)

        if let confirmedObject = managedObject {
            persistentContainer.viewContext.delete(confirmedObject)
        }
         
    }
    
    public func allManagedObjectURIsForSelectAll() ->  [URL: Bool] {

        
        guard let entityDesc = entityDescription else {
            logger.error("No entity description")
            fatalError("No entity description")
        }
        
        var deletionSelectionStatus = [URL: Bool]()
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetch.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let objectIDExpression = NSExpressionDescription()
        objectIDExpression.name = "objectID"
        objectIDExpression.expression = NSExpression.expressionForEvaluatedObject()
        objectIDExpression.expressionResultType = .objectIDAttributeType
        
        var propertiesToFetch: [Any] = [objectIDExpression]
        propertiesToFetch.append(contentsOf: entityDesc.properties)
        fetch.propertiesToFetch = propertiesToFetch
        //sort by objectID here instead of any supplied attribute name so it's closer to a random sample of (maxSamplesToReturn) size
        fetch.sortDescriptors = [NSSortDescriptor(key: "objectID", ascending: true,
                                                  selector: #selector(NSString.localizedStandardCompare(_:)))]
        
        do {
            
            let rawObjectDicts : [Dictionary<String, AnyObject>] = try persistentContainer.viewContext.fetch(fetch) as! [Dictionary<String, AnyObject>]
            
            var managedObjectID : NSManagedObjectID?
          
            for rawManagedObjectDictionaryRepresentation in rawObjectDicts {
                
                if let manObjID = (rawManagedObjectDictionaryRepresentation["objectID"] as! NSManagedObjectID?) {
                    managedObjectID = manObjID
                    if let unwrappedURL = managedObjectID?.uriRepresentation() {
                        deletionSelectionStatus[unwrappedURL] = true
                    }
                }
            }
        }  catch {
            print("getSampleDataForEachAttribute: \(error)")
          }
        
        
        
        
        return deletionSelectionStatus
    }
    
    public func clearField(field : Field) throws {
        
        guard let managedObjectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: field.managedObjectIDUrl)
        else {
            throw ModelErrors.unavailableManagedObject
        }
        
        let managedObject = try? persistentContainer.viewContext.existingObject(with:managedObjectID)
        
            //field.managedObjectIDUrl
        if let confirmedObject = managedObject {
            
            switch(field.type)  {
                case .stringAttributeType:
                    let stringField = field as! FieldString
                    confirmedObject.setValue("", forKey: stringField.attributeName)
                case .integer16AttributeType:
                    let int16Field = field as! FieldInt16
                    confirmedObject.setValue(0, forKey: int16Field.attributeName)
                case .integer32AttributeType:
                    let int32Field = field as! FieldInt32
                    confirmedObject.setValue(0, forKey: int32Field.attributeName)
                case .integer64AttributeType:
                    let int64Field = field as! FieldInt64
                    confirmedObject.setValue(0, forKey: int64Field.attributeName)
                case .decimalAttributeType:
                    let decimalField = field as! FieldDecimal
                    confirmedObject.setValue(0.00, forKey: decimalField.attributeName)
                case .doubleAttributeType:
                    let doubleField = field as! FieldDouble
                    confirmedObject.setValue(0.0, forKey: doubleField.attributeName)
                case .floatAttributeType:
                    let floatField = field as! FieldFloat
                    confirmedObject.setValue(0.0, forKey: floatField.attributeName)
                case .booleanAttributeType:
                    let boolField = field as! FieldBool
                    confirmedObject.setValue(false, forKey: boolField.attributeName)
                case .dateAttributeType:
                    let dateField = field as! FieldDate
                    confirmedObject.setValue(false, forKey: dateField.attributeName)
                case .binaryDataAttributeType:
                    let binaryField = field as! FieldBinary
                    confirmedObject.setValue(Data(base64Encoded: "0"), forKey: binaryField.attributeName)
                case .UUIDAttributeType:
                    let uuidField = field as! FieldUUID
                    confirmedObject.setValue(UUID(uuidString: "0"), forKey: uuidField.attributeName)
                case .URIAttributeType:
                    let uriField = field as! FieldURI
                    confirmedObject.setValue(URL(fileURLWithPath: "file:///dev/null"), forKey: uriField.attributeName)
                case .transformableAttributeType:
                    logger.error(" transformable clear")
                case .objectIDAttributeType:
                    logger.error("object clear")
                case .undefinedAttributeType:
                    logger.error("Tried to open EditContainer with a Field having an .undefined type")
                    fatalError("Tried to open EditContainer with a Field having an .undefined type")
                default:
                    logger.error("Tried to open EditContainer with a Field having an unhandled type")
                    fatalError("Tried to open EditContainer with a Field having an unhandled type")
            }
        }

        do {
           try persistentContainer.viewContext.save()
            self.batchController = nil //cause batchController to be reinstantiated on next read, so new value(s) are reflected
        } catch {
            logger.error("clear failed")
            print("clear failed")
            throw ModelErrors.undefinedError
            
        }
    }
    
    
    public func deleteField(field : Field) throws {
        
        guard let managedObjectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: field.managedObjectIDUrl)
        else {
            throw ModelErrors.unavailableManagedObject
        }
        
        let managedObject = try? persistentContainer.viewContext.existingObject(with:managedObjectID)
        
            //field.managedObjectIDUrl
        if let confirmedObject = managedObject {
            confirmedObject.setValue(nil, forKey: field.attributeName)
        }

        do {
           try persistentContainer.viewContext.save()
            self.batchController = nil //cause batchController to be reinstantiated on next read, so new value(s) are reflected
        } catch {
            print("delete failed")
            throw ModelErrors.undefinedError
            
        }
    }
    
    
    public func deleteRowContainingField(field : Field) throws {
        
        guard let managedObjectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: field.managedObjectIDUrl)
        else {
            throw ModelErrors.unavailableManagedObject
        }
        
        let managedObject = try? persistentContainer.viewContext.existingObject(with:managedObjectID)
        
            //field.managedObjectIDUrl
        if let confirmedObject = managedObject {
            persistentContainer.viewContext.delete(confirmedObject)
        }

        do {
           try persistentContainer.viewContext.save()
            self.batchController = nil //cause batchController to be reinstantiated on next read, so new value(s) are reflected
        } catch {
            print("delete failed")
            throw ModelErrors.undefinedError
            
        }
    }
    
    private func fieldForAttributeNameValueAndType(_ attributeName: String, value: AnyObject, managedObjectURL: URL, type: NSAttributeType) -> Field {
        
        var result : Field = FieldString(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: "ERR no match in fieldForAttributeNameValueAndType()")
        
        /*
         case .floatAttributeType:
             result = FieldFloat(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: NSString(string: decimalFormatterMaintainingDecimalDigits(NSNumber(value:value as! Float)).string(from: NSNumber(value:value as! Float))!).floatValue)
         case .doubleAttributeType:
             result = FieldDouble(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: NSString(string: decimalFormatterMaintainingDecimalDigits(NSNumber(value:value as! Double)).string(from: NSNumber(value:value as! Double))!).doubleValue)
         */
        
        
        if attributeName == "objectID" {
            //deliberately no field
        } else {
            
            switch type {
                
            case .stringAttributeType:
                result = FieldString(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! String )
            case .booleanAttributeType:
                result = FieldBool(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! Bool)
            case .integer16AttributeType:
                result = FieldInt16(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! Int16)
            case .integer32AttributeType:
                result = FieldInt32(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! Int32)
            case .integer64AttributeType:
                result = FieldInt64(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! Int64)
            case .decimalAttributeType:
                result = FieldDecimal(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! NSDecimalNumber)
            case .floatAttributeType:
                result = FieldFloat(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value:value as! Float)
            case .doubleAttributeType:
                result = FieldDouble(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value:value as! Double)
            case .URIAttributeType:
                result = FieldURI(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! URL)
            case .UUIDAttributeType:
                result = FieldUUID(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! UUID )
            case .dateAttributeType:
                result = FieldDate(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! Date )
            case .binaryDataAttributeType:
                result = FieldBinary(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: value as! Data)
            default:
                logger.error("Unhandled NSAttributeType in fieldForAttributeNameValueAndType()")
                fatalError("Unhandled NSAttributeType in fieldForAttributeNameValueAndType()")
            
            }
        }
            
        return result
    }
    
    public func dataForRow(_ rowIndex: Int) -> [Field] {
        
        guard let entityDesc = entityDescription else {
            return [FieldString(attributeName:"FAILURE" ,managedObjectIDUrl:URL(string:"google.ca")!, value: "FAILURE NO ENTITY DESCRIPTION")]
        }
        
        var fields = [Field]()
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetch.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let objectIDExpression = NSExpressionDescription()
        objectIDExpression.name = "objectID"
        objectIDExpression.expression = NSExpression.expressionForEvaluatedObject()
        objectIDExpression.expressionResultType = .objectIDAttributeType
        
        var propertiesToFetch: [Any] = [objectIDExpression]
        propertiesToFetch.append(contentsOf: entityDesc.properties)
        fetch.propertiesToFetch = propertiesToFetch
        fetch.sortDescriptors = [NSSortDescriptor(key: self.attributeNameForFetchSorting, ascending: true,
                                                  selector: #selector(NSString.localizedStandardCompare(_:)))]
        
        if self.batchController == nil  {
            self.batchController =   NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try self.batchController?.performFetch()
            } catch {
                logger.error("Failed to performFetch() on the NSFetchedResultsController")
            }
        }
        
        if let instantiatedBatchController = self.batchController {
            let fetchedObject : Dictionary<String, AnyObject> = instantiatedBatchController.object(at: IndexPath(row: rowIndex, section: 0)) as! Dictionary<String, AnyObject>
                
                var managedObjectID : NSManagedObjectID?
            
            
                if let manObjID = (fetchedObject["objectID"] as! NSManagedObjectID?) {
                    managedObjectID = manObjID
                
                    for (key, obj) in fetchedObject {
                        
                        if key != "objectID" {
                            
                            if let attributeType = entityDesc.attributesByName[key]?.attributeType {
                                fields.append(fieldForAttributeNameValueAndType(key, value: obj, managedObjectURL: (managedObjectID?.uriRepresentation())!, type: attributeType))
                                
                                }
                        }
                    }
                    
            //use attribute descriptions to determine if any keys are missing from the above dictionary
            //If any attributes are missing from the managedObject, fields still need to be generated for it in order to keep row and column alignment.
            //If an attribute isn't present, the generated placeholder field should be designated presentInPersistentStore = false so the lack of representation in the
            //store can be handled in UI and other logic (for example if the attribute is int32 it should read "--" instead of 0 in the table, when "saving" any edits, the model needs to add a new object instead of setting the value of an existing one). This presentInPersistentStore is redundant to just having a nil managedObjectIDUrl, but the code is clearer.
                    
                        let allAttributeInfo = attributeInfo()
                        
                        for (attributeName, type) in allAttributeInfo {
                            
                            if fetchedObject[attributeName] == nil {
                                
                                switch (type) {
                                    
                                case .stringAttributeType:
                                    var placeholderField = FieldString(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: "--")
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                
                                case .integer16AttributeType:
                                    var placeholderField = FieldInt16(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: Int16(INT16_MIN))
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .integer32AttributeType:
                                    var placeholderField = FieldInt32(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: Int32(-INT32_MAX))
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .integer64AttributeType:
                                    var placeholderField = FieldInt64(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: Int64(-INT64_MAX))
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .URIAttributeType:
                                    var placeholderField = FieldURI(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: URL(string: "NULL")!)
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                    
                                case .decimalAttributeType:
                                    var placeholderField = FieldDecimal(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: NSDecimalNumber(value: -INT16_MIN))
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .doubleAttributeType:
                                    var placeholderField = FieldDouble(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: Double(Double.leastNormalMagnitude))
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .floatAttributeType:
                                    var placeholderField = FieldFloat(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: Float(Float.leastNormalMagnitude))
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .dateAttributeType:
                                    var placeholderField = FieldDate(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: Date())
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .binaryDataAttributeType:
                                    var placeholderField = FieldBinary(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: Data("NOT PRESENT".utf8))
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .booleanAttributeType:
                                    var placeholderField = FieldBool(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: false)
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .UUIDAttributeType:
                                    var placeholderField = FieldUUID(attributeName:attributeName ,managedObjectIDUrl: (managedObjectID?.uriRepresentation())!, value: UUID())
                                    placeholderField.presentInPersistentStore = false
                                    fields.append(placeholderField)
                                case .undefinedAttributeType:
                                    let _ = logger.error("Hit unhandled case (undefinedAttributeType) for NSAttributeType in RowView")
                                case .transformableAttributeType:
                                    let _ = logger.error("Hit unhandled case (transformableAttributeType) for NSAttributeType in RowView")
                                case .objectIDAttributeType:
                                    let _ = logger.error("Hit unhandled case (objectIDAttributeType) for NSAttributeType in RowView")
                                @unknown default:
                                    let _ = logger.error("Hit unhandled *DEFAULT* case for NSAttributeType in RowView")
                                }
                            }
                        }
                    
                }
        }

        return fields
        
    }
    
    public func getSampleDataForEachAttribute(_ maxSamplesToReturn: Int = 100) -> Dictionary<String, [Field]> {
        
        guard let entityDesc = entityDescription else {
            return ["FAILURE" : [FieldString(attributeName:"FAILURE" ,managedObjectIDUrl:URL(string:"google.ca")!, value: "FAILURE NO ENTITY DESCRIPTION")]]
        }
        
        var result = Dictionary<String, [Field]>()

        //1. grab up to maxSamplesToReturn managedObjects
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        //ToDo: with this fetchOffset this logic will always sample the "last" maxSamplesToReturn
        // ^^ it matters less as sortDescriptors use objectID, so when sorted the entries are randomized initially, but given an unchanging data set the same fields will be returned
        fetch.fetchOffset = totalRows - maxSamplesToReturn
        fetch.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let objectIDExpression = NSExpressionDescription()
        objectIDExpression.name = "objectID"
        objectIDExpression.expression = NSExpression.expressionForEvaluatedObject()
        objectIDExpression.expressionResultType = .objectIDAttributeType
        
        var propertiesToFetch: [Any] = [objectIDExpression]
        propertiesToFetch.append(contentsOf: entityDesc.properties)
        fetch.propertiesToFetch = propertiesToFetch
        //sort by objectID here instead of any supplied attribute name so it's closer to a random sample of (maxSamplesToReturn) size
        fetch.sortDescriptors = [NSSortDescriptor(key: "objectID", ascending: true,
                                                  selector: #selector(NSString.localizedStandardCompare(_:)))]
        
        do {
            
            let rawObjectDicts : [Dictionary<String, AnyObject>] = try persistentContainer.viewContext.fetch(fetch) as! [Dictionary<String, AnyObject>]
            
            var managedObjectID : NSManagedObjectID?
          
            for rawManagedObjectDictionaryRepresentation in rawObjectDicts {
                
                if let manObjID = (rawManagedObjectDictionaryRepresentation["objectID"] as! NSManagedObjectID?) {
                    managedObjectID = manObjID
                
                    for (attributeName, value) in rawManagedObjectDictionaryRepresentation {
                        if result[attributeName] == nil  {
                            result[attributeName] = [Field]()
                        }
                        
                        if let attributeType = entityDesc.attributesByName[attributeName]?.attributeType {
                        
                            result[attributeName]?.append(fieldForAttributeNameValueAndType(attributeName, value: value, managedObjectURL: (managedObjectID?.uriRepresentation())!, type: attributeType))
                        }
                    }
                }
                
            }
            
            

        }  catch {
            print("getSampleDataForEachAttribute: \(error)")
          }
        
       
        return result
    }
    
    // # pragma mark -- DEBUG fxs
    
    private func dumpPrintAttributes() {
        
        guard let entityDesc = entityDescription else {
                return
        }
        for (attribName, attribDescription) in entityDesc.attributesByName {
            logger.debug("Attribute: \(attribName) Desc: \(attribDescription)")
        }
        
    }
}

enum ModelErrors: Error {
    case unavailableManagedObject
    case editingScratchError
    case invalidInputForDataTypeError
    case undefinedError
}
