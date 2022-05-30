//
//  EditViewBinaryseperatorPerByteRadioButtons.swift
//  
//
//  Created by Braden Ackerman on 2022-06-05.
//

import SwiftUI

enum BinaryEditseperatorPerByte: String {
    case noseparatorBetweenBytes = "noseparatorBetweenBytes"
    case separatorBetweenBytes = "separatorBetweenBytes"
}

struct EditViewBinaryseperatorPerByteRadioButtons: View {
    
    let callback: (String) -> ()
    
    @State var selectedId: String = BinaryEditseperatorPerByte.separatorBetweenBytes.rawValue
    
    var body: some View {
        HStack () {
            radioNoseperatorPerByte
            radioseperatorPerByte
        }
    }
    
    var radioNoseperatorPerByte: some View {
           RadioButtonField(
                id: BinaryEditseperatorPerByte.noseparatorBetweenBytes.rawValue,
                label: "Don't separate bytes",
                isMarked: selectedId == BinaryEditseperatorPerByte.noseparatorBetweenBytes.rawValue ? true : false,
                callback: radioGroupCallback
           )
       }
       
       var radioseperatorPerByte: some View {
           RadioButtonField(
               id: BinaryEditseperatorPerByte.separatorBetweenBytes.rawValue,
               label: "Separate bytes out",
               isMarked: selectedId == BinaryEditseperatorPerByte.separatorBetweenBytes.rawValue ? true : false,
               callback: radioGroupCallback
           )
       }
    
       func radioGroupCallback(id: String) {
           selectedId = id
           callback(id)
       }
    
}
