//
//  HexBinTextField.swift
//  
//
//  Created by Braden Ackerman on 2022-06-12.
//

import SwiftUI

/// A `TextField` replacement that limits user input to numbers.
public struct HexBinTextField: View {

    /// This is what consumers of the text field will access
    @Binding private var string: String
    @Binding var editMode: BinaryEditMode
    @Binding private var seperatorsPerByte: Bool
    
    private let title: LocalizedStringKey
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void

    /// Creates a text field with a text label generated from a localized title string.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - editMode: autoformat specifcation... unicode = none, hex/bin = approparite for type
    ///   - shouldseperatorPerByte: 0F AA or OFAA ... 10110010 01001101 or 1011001001001101
    ///   - onEditingChanged: An action thats called when the user begins editing `text` and after the user finishes editing `text`.
    ///     The closure receives a Boolean indicating whether the text field is currently being edited.
    ///   - onCommit: An action to perform when the user performs an action (for example, when the user hits the return key) while the text field has focus.
    public init(_ titleKey: LocalizedStringKey,
                stringValue: Binding<String>,
                editMode: Binding<BinaryEditMode>,
                seperatorsPerByte: Binding<Bool>,
                onEditingChanged: @escaping (Bool) -> Void = { _ in },
                onCommit: @escaping () -> Void = {}
    ) {
        
        _string = stringValue
        _editMode = editMode
        _seperatorsPerByte = seperatorsPerByte
        self.title = titleKey
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    public var body: some View {
        TextField(title, text: $string, onEditingChanged: onEditingChanged, onCommit: onCommit)
            .hexBinText(text: $string, editMode: $editMode, shouldseperatorPerByte: $seperatorsPerByte)
    }
}

struct HexBinTextField_Previews: PreviewProvider {
    @State private static var int: NSNumber?
    @State private static var double: NSNumber?
    @State private static var stringVal = ""
    
    static var previews: some View {
        VStack {
            HexBinTextField("Hexidecimal", stringValue: $stringVal, editMode: .constant(.hex), seperatorsPerByte: .constant(true))
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding()
            
            HexBinTextField("Binary", stringValue: $stringVal, editMode: .constant(.binary), seperatorsPerByte: .constant(true))
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .padding()
            
        }
    }
}
