//
//  RadioButtonField.swift
//  
//
//  Adapted from https://gist.github.com/mahmudahsan/0f8d448b437d63769ef7fad5569af945 by Braden Ackerman on 2022-06-05.
//

import SwiftUI

struct RadioButtonField: View {
        let id: String
        let label: String
        let size: CGFloat
        let color: Color
        let textSize: CGFloat
        let isMarked:Bool
        let callback: (String)->()
        
        init(
            id: String,
            label:String,
            size: CGFloat = 20,
            color: Color = Color.black,
            textSize: CGFloat = 14,
            isMarked: Bool = false,
            callback: @escaping (String)->()
            ) {
            self.id = id
            self.label = label
            self.size = size
            self.color = color
            self.textSize = textSize
            self.isMarked = isMarked
            self.callback = callback
        }
        
        var body: some View {
            Button(action:{
                self.callback(self.id)
            }) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.size*1.5, height: self.size*1.5)
                       
                    Text(label)
                        .font(Font.system(size: textSize))
                }.foregroundColor(self.color)
            }
            .foregroundColor(Color.white)
        }
}
