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
    let minimumMargins = 75.0
    
    @Binding var verticalScrollRatio: Float // 0 being top, 1 being bottomed out
    @Binding var horizontalScrollRatio: Float //0 being fully left (0 column leading aligned) and 1 being scroll max right (highest col trailing aligned)
    
    @State var isPortrait = false
    
    var body: some View {
        
        ZStack {
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    overlayShown = false
                }
                .opacity(overlayShown ? 1 : 0)
            
            HStack() {
                Spacer(minLength: isPortrait ? minimumMargins : minimumMargins * 3)
                VStack {
                    Spacer(minLength: isPortrait ? minimumMargins * 2.5 : minimumMargins * 0.5)
                    
                    //----------------------------
                    VStack {
                        Spacer()
                        ZStack {
                            
                             //vertical
                             VSlider(value: Binding(get: {
                                        verticalScrollRatio
                                    }, set: { (newVal) in
                                        verticalScrollRatio = newVal
                                    }))
                                        .rotationEffect(.degrees(180.0), anchor: .center)
                                        .padding(.top)
                             
                             
                             //horizontal
                            Slider(value: Binding(get: {
                                horizontalScrollRatio
                           }, set: { (newVal) in
                               horizontalScrollRatio = newVal
                           }))
                               .accentColor(Color(.orange))
                               .padding(.leading)
                               .padding(.trailing)
                        }
                        HStack {
                                Button(action: {
                                    verticalScrollRatio = 0.0
                                    horizontalScrollRatio = 0.0
                                }, label: {
                                    Image(systemName: "arrow.clockwise")
                                        .resizable()
                                        .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
                                        .background(Color.black.opacity(0.0))
                                        .foregroundColor(Color.white)
                                })
                                .padding(.leading)
                                .padding(.bottom)
                            
                                Spacer()
                            
                                Button(action: {
                                    overlayShown = false
                                }, label: {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .frame(width: sfSymbolButtonDimension, height: sfSymbolButtonDimension)
                                        .background(Color.black.opacity(0.0))
                                        .foregroundColor(Color.white)
                                })
                                .padding(.trailing)
                                .padding(.bottom)
                                   
                        }
                    }.background(Color.black).opacity(overlayShown ? shownBackgroundOpacity : 0)
                    .opacity(overlayShown ? 1 : 0)
                    //----------------------------
                    
                    Spacer(minLength: isPortrait ? minimumMargins * 2.5 : minimumMargins * 0.5)
                }
                Spacer(minLength: isPortrait ? minimumMargins : minimumMargins * 3)
            }
        }.onReceive(NotificationCenter.Publisher(center: .default, name: UIDevice.orientationDidChangeNotification)) { _ in
                guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                self.isPortrait = scene.interfaceOrientation.isPortrait
        }
    }
}

struct GrossScrollControlOverlayView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GrossScrollControlOverlayView(overlayShown: .constant(true), verticalScrollRatio: .constant(0.0), horizontalScrollRatio: .constant(0.0))
    }
}
