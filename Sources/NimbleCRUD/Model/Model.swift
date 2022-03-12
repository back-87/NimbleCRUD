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
    
    var entityDescription : NSEntityDescription?
    
    private var _dataLoaded = false
    
    private var _totalRows : Int = 0
    
    public var totalRows : Int {
        return _totalRows
    }
    
    var batchController : NSFetchedResultsController<NSFetchRequestResult>?
    
    public var dataLoaded : Bool {
        return _dataLoaded
    }

    
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
        //self.request = NSFetchRequest(entityName: self.entityName)
        findAndSetEntity(entityName: entityName)
    }
    
    public init(modelName : String, entityName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        self.entityName = entityName
        self.attributeNameForFetchSorting = "objectID"
        
        loadContainer()
        //self.request = NSFetchRequest(entityName: self.entityName)
        findAndSetEntity(entityName: entityName)
    }
    
    private func loadContainer() {
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
          if let error = error as NSError? {
            fatalError("Failed to load stores: \(error), \(error.userInfo)")
          } else {
              print("Loaded NSPersistentContainer (\(self.persistentContainer.name)) successfully.")
          }
        })
        
    }
    
    private func findAndSetEntity(entityName: String) {
        for (name, entityRef) in persistentContainer.managedObjectModel.entitiesByName {
            if(name == entityName) {
                entityDescription = entityRef
                _dataLoaded = true
            }
        }
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            _totalRows = try persistentContainer.viewContext.count(for: fetch)
        } catch {
            print("Failed to determine total number of rows to expect")
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
    
    public func saveFIeld(field : Field) {
        /*
         
         var testSaveManagedObjectID : NSManagedObjectID?
         
        if let actualOjbID = testSaveManagedObjectID {
            var managedObject = try? persistentContainer.viewContext.existingObject(with:actualOjbID)
            if let confirmedObject = managedObject {
                confirmedObject.setValue("BRADENROCKS", forKey: stringKey)
            }
            print("did modify, now changed records is: \(persistentContainer.viewContext.updatedObjects.count)")
            do {
               try persistentContainer.viewContext.save()
            } catch {
                print("save failed")
                fatalError()
            }
        }
         */
    }
    
    
    private func fieldForAttributeNameAndValue(_ attributeName: String, value: AnyObject, managedObjectURL: URL) -> Field {
        //print("SUCCESSFUL CAST TO MANAGED OBJECT ID: \(manObjID)")
        
        var result : Field = FieldString(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: "ERR no match in fieldForAttributeNameAndValue()")
        
        if(attributeName == "objectID") {
            //deliberately no field
        }
        else if let str = value as? String {
            result = FieldString(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: str)
        }
        else if let num = value as? Double {
            result = FieldDouble(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: num)
        }
        else if let num = value as? Float {
            result = FieldFloat(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: num)
        }
        else if let num = value as? Int64 {
            result = FieldInt64(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: num)
        }
        else if let num = value as? Int32 {
            result = FieldInt32(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: num)
        }
        else if let num = value as? Int16 {
            result = FieldInt16(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: num)
        }
        else if let url = value as? URL {
            result = FieldURI(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: url)
        }
        else if let uuid = value as? UUID {
            result = FieldUUID(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: uuid)
        }
        else if let date = value as? Date {
            result = FieldDate(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: date)
        }
        else if let data = value as? Data {
            result = FieldBinary(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: data)
        }
        else if let bool = value as? Bool {
            result = FieldBool(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: bool)
        }
        else if let decimal = value as? NSDecimalNumber {
            result = FieldDecimal(attributeName:attributeName ,managedObjectIDUrl: managedObjectURL, value: decimal)
        }
        return result
    }
    
    public func dataForRow(_ rowIndex: Int) -> [Field] {
        
        guard let entityDesc = entityDescription else {
            return [FieldString(attributeName:"FAILURE" ,managedObjectIDUrl:URL(string:"google.ca")!, value: "FAILURE NO ENTITY DESCRIPTION")]
        }
        
        var fields = [Field]()
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        //fetch.propertiesToFetch = ["testAttribString"]
        //fetch.fetchOffset = totalRows - rowIndex
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
        
        if((self.batchController == nil)) {
            self.batchController =   NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try self.batchController?.performFetch()
            } catch {
                print("Failed to performFetch() on the NSFetchedResultsController")
            }
        }
        
        if let instantiatedBatchController = self.batchController {
            let fetchedObject : Dictionary<String, AnyObject> = instantiatedBatchController.object(at: IndexPath(row: rowIndex, section: 0)) as! Dictionary<String, AnyObject>
                
                var managedObjectID : NSManagedObjectID?
            
                if let manObjID = (fetchedObject["objectID"] as! NSManagedObjectID?) {
                    managedObjectID = manObjID
                
                    for (key, obj) in fetchedObject {
                        if(key != "objectID") {
                            fields.append(fieldForAttributeNameAndValue(key, value: obj, managedObjectURL: (managedObjectID?.uriRepresentation())!))
                        }
                    }
                    
                        //use attribute descriptions to determine if any keys are missing from the above dictionary
                        //If any attributes are missing from the managedObject, fields still need to be generated for it in order to keep row and column alignment.
                        //If an attribute isn't present, the generated placeholder field should be designated presentInPersistentStore = true so the lack of representation in the
                        //store can be handled in UI and other logic (for example if the attribute is int32 it should read "--" instead of 0 in the table
                        let allAttributeInfo = attributeInfo()
                        
                        for (attributeName, type) in allAttributeInfo {
                            
                            if(fetchedObject[attributeName] == nil) {
                                print("found a missing attribute in this managed object dictionary named: \(attributeName). Creating a placeholder field for it.")
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
                                    let _ = print("Hit unhandled case (undefinedAttributeType) for NSAttributeType in RowView")
                                case .transformableAttributeType:
                                    let _ = print("Hit unhandled case (transformableAttributeType) for NSAttributeType in RowView")
                                case .objectIDAttributeType:
                                    let _ = print("Hit unhandled case (objectIDAttributeType) for NSAttributeType in RowView")
                                @unknown default:
                                    let _ = print("Hit unhandled *DEFAULT* case for NSAttributeType in RowView")
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
                        if(result[attributeName] == nil) {
                            result[attributeName] = [Field]()
                        }
                        result[attributeName]?.append(fieldForAttributeNameAndValue(attributeName, value: value, managedObjectURL: (managedObjectID?.uriRepresentation())!))
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
            print("Attribute: \(attribName) Desc: \(attribDescription)")
        }
        
    }
}
