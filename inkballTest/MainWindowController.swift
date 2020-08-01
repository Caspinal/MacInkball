//
//  MainWindowController.swift
//  inkballTest
//
//  Created by Connor Aspinall on 29/07/2020.
//

import Cocoa

class MainWindowController: NSWindowController {

    var win:NSWindowController?
    var tools = ToolBoxController(nibName: "ToolBoxController", bundle: Bundle.main)
    
    @IBAction func ToggleTools(_ sender: Any) {
        
        
        self.win?.showWindow(self)
        
    }
    override func windowDidLoad() {
        super.windowDidLoad()
    
        let wind = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 300, height: 500), styleMask: [.miniaturizable,.closable,.titled], backing: .buffered, defer: true)
                    
        wind.contentView?.addSubview(tools.view)
        self.win = NSWindowController(window: wind)
        
    }

}
