//
//  NimbleCRUDView.swift
//  
//
//  Created by Braden Ackerman on 2022-03-11.
//

import SwiftUI

public struct NimbleCRUDView: View {
    
    private ObservableObject viewModel = NimbleCRUDViewModel()
    
    public init() {
        
    } //needed for package consumers
    
    public var body: some View {
        ZStack {
            //2 buttons activated by double tap taking up half the view vertically  on the "bottom" of the ZStack
            // these are used to scroll the columns left or right (assuming there's a column in that direction that's hidden by being offscreen. The double tap attention grabbing hints will animate if there's a column hidden offscreeen on that respective side both when this view appears and after the user scrolls the columns
            // also "Add record" and other buttons not occupying the same z plane as the scroll buttons exist here
                
            HStack {
                Button.onTapGesture(count: 2) {
                    print("got a double tap on the left side scroll button")
                }
                Button.onTapGesture(count: 2) {
                    print("got a double tap on the right side scroll button")
                }
            }
            
            //Second from bottom (middle at time of writing) of zstack are the indicators / hints / attention grabbers for the column scrolling described better above
            VStack {
                Spacer()
                
                HStack {
                    DoubleTapPathView()
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                    
                    DoubleTapPathView()
                        .resizable()
                        .scaledToFit()
                }
                
                Spacer()
            }
            
            
            //top of ZStack is the actual rows and columns of the table

        }
    }
}

public struct NimbleCRUDView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
