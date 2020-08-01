//
//  LCDCustomView.swift
//  inkballTest
//
//  Created by Connor Aspinall on 28/07/2020.
//

import Cocoa
import SwiftUI

class LCDCustomView: NSView {

    
  
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        print(dirtyRect)
        NSColor.red.setFill()
        NSBezierPath(rect: dirtyRect).fill()
        print("LCD moved to \(self.frame)")
        let host = NSHostingView(rootView: LCDView())
        host.frame = dirtyRect
        self.addSubview(host)
    
    }
    
}


