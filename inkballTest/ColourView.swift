//
//  ColourView.swift
//  inkballTest
//
//  Created by Connor Aspinall on 26/07/2020.
//

import SwiftUI

struct ColourView: View {
    
    var colours:[NSColor]?
    var pop:NSPopover?
    //[.systemBlue,.systemPurple,.systemPink,.systemRed,.systemOrange,.systemYellow,.systemGreen,.systemGray]
    @State var selected:NSColor
    @State var referenceNode:blockNode
    
    var body: some View {
        VStack{
        HStack{
            ForEach(self.colours!, id: \.self) { c in
                
                ZStack{
                
                    Button(action: {self.selected = c; self.referenceNode.setColorFromArray(colours: self.colours!, colour: c)}){
                Circle().foregroundColor(Color.init(c)).frame(width: 24, height: 24, alignment: .center)
                    }.buttonStyle(PlainButtonStyle())
                  
                    if(c == self.selected){
                Circle().foregroundColor(Color.white).frame(width: 8, height: 8, alignment: .center)
                    }
                }
            }
            }
            
            HStack{
            Button(action: {self.referenceNode.removeFromParent(); self.pop?.performClose(self.pop)}){
                
                Text("Delete")
            }
            Button(action: {self.pop?.performClose(self.pop)}){
                
                Text("Close")
            }
            }
        }
    }
}

//struct ColourView_Previews: PreviewProvider {
//    
//
//    static var previews: some View {
//       // let c:NSColor? = NSColor.systemOrange
//        ColourView(colours: [.systemBlue,.systemPurple,.systemPink,.systemRed,.systemOrange,.systemYellow,.systemGreen,.systemGray], selected: nil)
//    }
//}
