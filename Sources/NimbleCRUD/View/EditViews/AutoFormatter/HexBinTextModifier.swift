//
//  HexBinTextModifier.swift
//  
//
//  Created by Braden Ackerman on 2022-06-07.
//

import SwiftUI
import os

public struct HexBinTextModifier: ViewModifier {
    /// Should the user be allowed to enter a decimal number, or an integer
    @Binding public var editMode: BinaryEditMode //inverse indicates binary
    /// Should the user be allowed to enter a negative number
    @Binding public var shouldseperatorPerByte: Bool  //0F AA or OFAA ... 10110010 01001101 or 1011001001001101

    /// The string that the text field is bound to
    @Binding public var text: String
        
    /// A modifier that observes any changes to a string, and updates that string to remove any non-numeric characters.
    /// It also will convert that string to a `NSNumber` for easy use.
    ///
    /// - Parameters:
    ///   - text: The string that this should observe and filter
    ///   - isHex: this formatter supports hex and binary representations, this is the indicator between the,
    ///   - shouldseperatorPerByte: 0F AA or OFAA ... 10110010 01001101 or 1011001001001101
    public init(text: Binding<String>, editMode: Binding<BinaryEditMode>, shouldseperatorPerByte: Binding<Bool>) {
        _text = text
        _editMode = editMode
        _shouldseperatorPerByte = shouldseperatorPerByte
    }

    public func body(content: Content) -> some View {
        return content
            .onChangeShimmed(of: text) { newValue in
                
                switch(editMode) {
                    case .hex:
                        text = newValue.hexidecimalStringRepresentation(seperatorPerByte: shouldseperatorPerByte)
                    case .binary:
                        text = newValue.binaryStringRepresentation(seperatorPerByte: shouldseperatorPerByte)
                    case .unicode:
                        fallthrough
                    default:
                        text = newValue
                }
            }
    }
}

public extension View {
    /// A modifier that observes any changes to a string, and updates that string to remove any non-numeric characters.
    /// It also will convert that string to a `NSNumber` for easy use.
    func hexBinText(text: Binding<String>, editMode: Binding<BinaryEditMode>, shouldseperatorPerByte: Binding<Bool>) -> some View {
        modifier(HexBinTextModifier(text: text, editMode: editMode, shouldseperatorPerByte: shouldseperatorPerByte))
    }
}
