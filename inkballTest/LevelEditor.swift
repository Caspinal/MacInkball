//
//  LevelEditor.swift
//  inkballTest
//
//  Created by Connor Aspinall on 25/07/2020.
//

import Cocoa
import SwiftUI

class LevelEditor: NSViewController {

    @IBOutlet weak var comboColour: NSComboBox!
    
    var colours:[NSColor]?
    var selected:NSColor?
    var node:blockNode?
    var pop:NSPopover?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
       
        let scv = ColourView(colours: self.colours, pop: self.pop,selected: self.selected ?? NSColor.systemBlue,referenceNode: self.node ?? blockNode())
       
        
//        scv.colours = self.colours
//        scv.selected = self.selected ?? NSColor.systemBlue
        
        let colView = NSHostingView(rootView: scv)
        colView.frame = NSRect(x: 0, y: 0, width: 300, height: 64)
        self.view.addSubview(colView)
        
        
        //comboColour.cell = CustomComboCell() //as NSCell
    }
    
}
