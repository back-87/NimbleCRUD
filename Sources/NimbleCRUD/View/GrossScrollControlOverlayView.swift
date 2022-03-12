//
//  GrossScrollControlOverlayView.swift
//  SwiftPlaySecond
//
//  Created by Braden Ackerman on 2022-03-29.
//

import SwiftUI

struct GrossScrollControlOverlayView: View {
    
    @Binding var overlayShown : Bool
    let shownBackgroundOpacity = 0.75
    
    @Binding var verticalScrollRatio: Float // 0 being top, 1 being bottomed out
    @Binding var horizontalScrollRatio: Float //0 being fully left (0 column leading aligned) and 1 being scroll max right (highest col trailing aligned)
    
    var body: some View {
        
        HStack {
            Spacer()
                VStack {
                    Spacer()
                            ZStack {
                                
                                let horizontalSlider =    Slider(value: Binding(get: {
                                    horizontalScrollRatio
                               }, set: { (newVal) in
                                   horizontalScrollRatio = newVal
                               }))
                        //.accentColor(Color(.systemGray2))
                                
                                
                                //vertical
                                VSlider(value: Binding(get: {
                                            verticalScrollRatio
                                       }, set: { (newVal) in
                                           verticalScrollRatio = newVal
                                       })).rotationEffect(.degrees(180.0), anchor: .center)
                                        //need to set frame due to rotation
                                
                                
                                //horizontal
                                horizontalSlider
                                    
                            }.opacity(overlayShown ? 1 : 0)
                            
                                            
                            Button(action: {
                                verticalScrollRatio = 0.0
                                horizontalScrollRatio = 0.0
                            }, label: {
                                Text("RESET")
                            }).background(Color.black).opacity(shownBackgroundOpacity)
                                .foregroundColor(Color.white)
                    
                    Spacer()
                }.opacity(overlayShown ? 1 : 0)
                    .background(Color.gray).opacity(shownBackgroundOpacity)
                    .opacity(overlayShown ? 1 : 0)
                    .padding()
                
                Spacer()
            
        }

    }
}

struct GrossScrollControlOverlayView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GrossScrollControlOverlayView(overlayShown: .constant(true), verticalScrollRatio: .constant(0.0), horizontalScrollRatio: .constant(0.0))
    }
}
