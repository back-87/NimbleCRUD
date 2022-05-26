//
//  SwiftUIView.swift
//  
//
//  Created by Braden Ackerman on 2022-05-28.
//

import SwiftUI

struct EditViewString: View {
    
    @ObservedObject var viewModel : ViewModel
    @State var stringValue : String = ""
    
    var body: some View {
        
        TextEditor(text: $stringValue).onAppear {
            stringValue = (viewModel.selectedFieldForEditing as! FieldString).value
            viewModel.temporaryEditedStringValue = stringValue
        }.onChange(of: stringValue, perform: { value in
            viewModel.temporaryEditedStringValue = value
        }).overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black)
        )
        .padding(.leading)
        .padding(.trailing)
    }
}

struct EditViewString_Previews: PreviewProvider {
    static var previews: some View {
        EditViewString(viewModel: ViewModel(modelName: "test model name", entityName: "someEntityName"))
    }
}
