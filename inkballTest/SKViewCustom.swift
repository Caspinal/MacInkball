//
//  SKViewCustom.swift
//  inkballTest
//
//  Created by Connor Aspinall on 23/07/2020.
//

import Cocoa
import SpriteKit

class SKViewCustom: SKView {

    override var acceptsFirstResponder: Bool {return true}
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
    
        self.allowedTouchTypes = [.direct,.indirect]
        self.wantsRestingTouches = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func save(sender:Any?){
        print("save")
    }
    
    override func touchesBegan(with event: NSEvent) {
        let s = self.scene as! GameScene
        s.touchesBegan(with: event)
    }
    
    override func touchesMoved(with event: NSEvent) {
        let s = self.scene as! GameScene
        s.touchesMoved(with: event)
    }
    
    override func touchesEnded(with event: NSEvent) {
        let s = self.scene as! GameScene
        s.touchesEnded(with: event)
    }
    
}
