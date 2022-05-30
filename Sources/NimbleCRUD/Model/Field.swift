//
//  Field.swift
//  
//
//  Created by Braden Ackerman on 2022-04-01.
//

import CoreData

protocol Field {
    var attributeName: String { get }
    var type: NSAttributeType { get }
    var managedObjectIDUrl: URL {get set}
    var presentInPersistentStore: Bool {get}
}

struct FieldObjectID: Field {
        
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.objectIDAttributeType
    public var value : AnyObject
    public var presentInPersistentStore: Bool = true
    
}

struct FieldURI: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.URIAttributeType
    public var value: URL
    public var presentInPersistentStore: Bool = true
}

struct FieldUUID: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.UUIDAttributeType
    public var value : UUID
    public var presentInPersistentStore: Bool = true
}

struct FieldBinary: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.binaryDataAttributeType
    public var value : Data
    public var presentInPersistentStore: Bool = true
}

struct FieldDate: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.dateAttributeType
    public var value : Date
    public var presentInPersistentStore: Bool = true
}

struct FieldBool: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.booleanAttributeType
    public var value : Bool
    public var presentInPersistentStore: Bool = true
}

struct FieldString: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.stringAttributeType
    public var value : String
    public var presentInPersistentStore: Bool = true
}

struct FieldFloat: Field{
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.floatAttributeType
    public var value : Float
    public var presentInPersistentStore: Bool = true
}

struct FieldDouble: Field{
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.doubleAttributeType
    public var value : Double
    public var presentInPersistentStore: Bool = true
}

struct FieldDecimal: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.decimalAttributeType
    public var value : NSDecimalNumber
    public var presentInPersistentStore: Bool = true
}

struct FieldInt64: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.integer64AttributeType
    public var value : Int64
    public var presentInPersistentStore: Bool = true
}

struct FieldInt32: Field {
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.integer32AttributeType
    public var value : Int32
    public var presentInPersistentStore: Bool = true
}

struct FieldInt16: Field{
    public var attributeName: String
    public var managedObjectIDUrl: URL
    public var type = NSAttributeType.integer16AttributeType
    public var value : Int16
    public var presentInPersistentStore: Bool = true
}

