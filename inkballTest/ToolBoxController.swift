//
//  ToolBoxController.swift
//  inkballTest
//
//  Created by Connor Aspinall on 29/07/2020.
//

import Cocoa
import SwiftUI
struct DefualtColourView: View {
    
    var colours:[NSColor]?
    
    //
    @State var selected:NSColor
//    @State var referenceNode:blockNode
    
    var body: some View {
        
        HStack{
            ForEach(self.colours!, id: \.self) { c in
                
                ZStack{
                
                    Button(action: {self.selected = c;}){
                Circle().foregroundColor(Color.init(c)).frame(width: 24, height: 24, alignment: .center)
                    }.buttonStyle(PlainButtonStyle())
                  
                    if(c == self.selected){
                Circle().foregroundColor(Color.white).frame(width: 8, height: 8, alignment: .center)
                    }
                }
            }
        }
    }
}

class ToolBoxController: NSViewController {

 
    @IBOutlet weak var colourHost:NSView?
    
     let colours = UserColourPalettes()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
       
        
        let col = DefualtColourView(colours: colours.Palettes[0].colours!, selected: colours.Palettes[0].colours![0])
        let host = NSHostingView(rootView: col)
        host.frame = colourHost?.frame as! NSRect
        self.colourHost?.addSubview(host)
        
    }
    
}
