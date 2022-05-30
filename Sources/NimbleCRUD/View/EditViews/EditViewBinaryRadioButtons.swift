//
//  EditViewBinaryRadioButtons.swift
//  
//
//  Adapted from https://gist.github.com/mahmudahsan/0f8d448b437d63769ef7fad5569af945 by Braden Ackerman on 2022-06-05.
//

import SwiftUI

public enum BinaryEditMode: String {
    case unicode = "unicode"
    case hex = "hex"
    case binary = "binary"
}

struct EditViewBinaryRadioButtons: View {
    
    @Binding var selectedId: BinaryEditMode
    
    let callback: (BinaryEditMode) -> ()
    
    init (selectedEditMode: Binding<BinaryEditMode>, _ callback: @escaping (BinaryEditMode) -> ()) {
        _selectedId = selectedEditMode
        self.callback = callback
    }

    
    var body: some View {
        HStack () {
            radiounicodeMode
            radioHexMode
            radioBinaryMode
        }
    }
    
    var radiounicodeMode: some View {
           RadioButtonField(
                id: BinaryEditMode.unicode.rawValue,
                label: BinaryEditMode.unicode.rawValue,
                isMarked: selectedId == BinaryEditMode.unicode ? true : false,
                callback: radioGroupCallback
           )
       }
       
       var radioHexMode: some View {
           RadioButtonField(
                id: BinaryEditMode.hex.rawValue,
                label: BinaryEditMode.hex.rawValue,
                isMarked: selectedId == BinaryEditMode.hex ? true : false,
               callback: radioGroupCallback
           )
       }
    
    var radioBinaryMode: some View {
        RadioButtonField(
            id: BinaryEditMode.binary.rawValue,
            label: BinaryEditMode.binary.rawValue,
            isMarked: selectedId == BinaryEditMode.binary ? true : false,
            callback: radioGroupCallback
        )
    }
       
       func radioGroupCallback(id: String) {
           
           switch (id) {
               case BinaryEditMode.binary.rawValue:
                      selectedId = BinaryEditMode.binary
               case BinaryEditMode.hex.rawValue:
                      selectedId = BinaryEditMode.hex
               case BinaryEditMode.unicode.rawValue:
                    selectedId = BinaryEditMode.unicode
           default:
               logger.critical("Unhandled BinaryEditMode in radioGroupCallback")
           }
           
           callback(selectedId)
       }
    
}
