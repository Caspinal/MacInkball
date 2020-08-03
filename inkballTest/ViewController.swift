//
//  ViewController.swift
//  inkballTest
//
//  Created by Connor Aspinall on 23/07/2020.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    var scene:GameScene?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
       let view = SKViewCustom(frame: self.view.frame)
        
        
        view.autoresizingMask = [.width,.height]
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene()
                // Set the scale mode to scale to fit the window
        scene.scaleMode = .fill
        scene.size = view.frame.size
        scene.anchorPoint = CGPoint(x: 0,y: 0);
                // Present the scene
        self.scene = scene
        view.presentScene(scene)
            
            
        view.ignoresSiblingOrder = true
            
        view.showsFPS = true
        view.showsNodeCount = true
        self.view = view

    }
    
//    @IBAction func save(_ sender: Any) {
//       
//      
//    
//    }
    
    
}

