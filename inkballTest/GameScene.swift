//
//  GameScene.swift
//  inkballTest
//
//  Created by Connor Aspinall on 23/07/2020.
//

import SpriteKit
import GameplayKit
import CoreGraphics


class Ball:SKShapeNode{
    
    override init() {
           super.init()
    }
    
     convenience init( cellSize:Int) {
        self.init()
        self.init(ellipseIn: CGRect(x: 0, y: 0, width: CGFloat(cellSize), height: CGFloat(cellSize)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class blockNode:SKShapeNode{
    
    var colourIndex = 0;
    
    func setColorFromArray(colours:[NSColor],index:Int){
        if(index > colours.count || index < 0){
            self.fillColor = colours[0]
            self.colourIndex = 0
            print("Index out of range \(index)")
            return
        }
        self.fillColor = colours[index]
        self.colourIndex = index
        
    }
    
    func setColorFromArray(colours:[NSColor],colour:NSColor){
          //
          //self.colourIndex = index
          var i = 0
        for c in colours {
            
            if(c == colour){
                self.colourIndex = i
                self.fillColor = colours[i]
                return
            }
            
            i+=1
        }
        
        
    }
    
    func addPhysicsBody(){
        
//        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
//        self.physicsBody?.affectedByGravity = false
//        self.physicsBody?.pinned = true
//        self.physicsBody?.isDynamic = false
    }
    
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    var currentPathNode:SKShapeNode?
    var currentPath:CGMutablePath?
    var click = false;
    var texture = SKTexture(imageNamed: "texture")
    let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.2)
    let fadeIn = SKAction.fadeAlpha(to: 0.6, duration: 0.2)
    let touchedNode = SKShapeNode(circleOfRadius: 20)
    let cellSize = 32
    var mapWidth = 0
    var mapHeight = 0
    var tiles = 0
    var balls:[Ball] = []
    var board:[[SKNode]]?
    
    
    enum PlayMode{
        
        case play
        case edit
        case pause
    }
    
    
    
    var playMode:PlayMode = .edit
    
    let ColourPal = UserColourPalettes()
    var colours:[NSColor] = [.systemBlue,.systemPurple,.systemPink,.systemRed,.systemOrange,.systemYellow,.systemGreen,.systemGray]
    
    
   
    @IBAction func save(_ sender: Any) {
        self.saveMap()
    }
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: 1024, height: 576)
        self.touchedNode.fillColor = NSColor.controlColor
        self.touchedNode.alpha = 0.0
        self.touchedNode.zPosition = 100
        self.touchedNode.name = "TouchNode"
        self.scene?.addChild(self.touchedNode)
        print("Scene size = \(self.size)")
        
        self.mapWidth = Int(self.size.width)/cellSize
        self.mapHeight = Int(self.size.height)/cellSize
        
        self.board = Array(repeating: Array(repeating: SKNode(), count: self.mapHeight), count: self.mapWidth)
        
        print("Map size = \(self.mapWidth) : \(self.mapHeight)")
        
        self.makeLineGrid(rows: self.mapWidth, cols: self.mapHeight ,size: self.cellSize)
        self.loadMap(url: Bundle.main.url(forResource: "Border", withExtension: "inkBall"))
        let b = Ball(cellSize: self.cellSize)
        b.position = CGPoint(x:96,y:96)
       
        self.balls.append(b)
        self.addChild(b)
    }
    
    func makeLineGrid(rows:Int,cols:Int,size:Int){
        
        for x in (0..<rows){
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: x*size, y: 0))
            path.addLine(to: CGPoint(x: x*size, y: Int(self.size.height)))
            let l = SKShapeNode(path:path)
            l.strokeColor = NSColor.darkGray
            l.name = "GridLine - x"
            self.scene?.addChild(l)
   
        }
        
        for y in (0..<cols){
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: y*size))
            path.addLine(to: CGPoint(x: Int(self.size.width), y: y*size))
            let l = SKShapeNode(path:path)
            l.strokeColor = NSColor.darkGray
            self.scene?.addChild(l)
            l.name = "GridLine - y"
        }
        
    }
    
    func loadMap(url:URL?){
       
//      let openPanel = NSOpenPanel()
//        openPanel.allowedFileTypes = ["inkBall"]
//            openPanel.allowsOtherFileTypes = false
//        let result = openPanel.runModal()
//
//
//        if(result == NSApplication.ModalResponse.OK){
        if(url != nil){
            print("Open \(url)")
            
             //let file = try! FileHandle(forReadingFrom: openPanel.url!)
            let data = try! Data(contentsOf: url!)
            print(data)
            
            var dataArray:[ObjectData] = []
            
            data.withUnsafeBytes { (u8Ptr: UnsafePointer<ObjectData>) in
                let rawPtr = UnsafePointer<ObjectData>(u8Ptr)
                let buffer = UnsafeBufferPointer<ObjectData>(start: rawPtr, count: data.count)
               // dataArray = Array(buffer) as [ObjectData]
                var bitCount  = 0
                for d in buffer{
                    if(bitCount >= data.count-MemoryLayout<ObjectData>.size){
                        break
                    }
                    if(d.name == nil){
                        break
                    }
                    print(d)
                    dataArray.append(d)
                    let bn = blockNode(rect: CGRect(x: 0, y: 0, width: cellSize, height: cellSize), cornerRadius: 4.0)
                    bn.position = d.position!
                    bn.setColorFromArray(colours: self.colours, index: d.colourIndex!)
                    bn.name = d.name
                    bn.strokeColor = NSColor.darkGray
                    bn.addPhysicsBody()
                    self.scene?.addChild(bn)
                    bitCount += MemoryLayout<ObjectData>.size
                    
                }
            }
            
           
              
            //print(dataArray)
        }
        
        
    }
    
    struct ObjectData{
        var name:String?
        var position:CGPoint?
        var colourIndex:Int?
    }
    
    func saveMap(){
        
        
        
        //print("saving \(String(describing: scene?.children.count)) nodes")
        var mapData:[ObjectData] = []
        for child:SKNode in (scene?.children)! {
            let n = child as? blockNode
            
            if(n?.name?.contains("Tile") == true){
                
                let data = ObjectData(name: n?.name, position: n?.position, colourIndex: n?.colourIndex)
                
                mapData.append(data)
                
            }
        }
        let buffer = UnsafeBufferPointer(start: mapData, count: mapData.count)
        let d =  Data(buffer: buffer)
    
        print(d)
        
       
        
        let savePanel = NSSavePanel()
            
        savePanel.allowedFileTypes = ["inkBall"]
        savePanel.allowsOtherFileTypes = false
        
        let result = savePanel.runModal()
        
        if(result == NSApplication.ModalResponse.OK){
            let path = savePanel.url?.path //Bundle.main.bundlePath + "/map/map.inkball"
            FileManager.default.createFile(atPath: path!, contents: nil, attributes: nil)
                let fh = FileHandle(forWritingAtPath:path!)
                       if(fh != nil){
                           fh?.seekToEndOfFile()
                           fh?.write(d)
                           fh?.closeFile()
                       }else{
                           let alert = NSAlert()
                           alert.alertStyle = .critical
                           alert.messageText = "Map could not be saved"
                        alert.informativeText = "\(path!) is inaccessable."
                           alert.runModal()
                       }
        }
               
           
      
        
    }
    
    
    func clearMap(){
        
        for child in self.children {
            
            let name:String? = child.name
            if (!(name?.contains("GridLine") ?? false) && !(name?.contains("TouchNode") ?? false)) {
                print("removing \(child.name ?? "")")
                child.removeFromParent()
            }
            
            
        }
        
    }
    
    func clearInk(){
        
        self.currentPath = CGMutablePath()
        for child in self.children {
            
            let name:String? = child.name
            print(name)
            if ((name?.contains("Ink") ?? false)) {
                print("removing \(child.name ?? "")")
                child.removeFromParent()
            }
            
            
        }
        
    }
    
    
    override func rightMouseDown(with event: NSEvent) {
         let mpos = event.locationInWindow
        let norm = CGPoint(x:mpos.x/self.size.width,y:mpos.y/self.size.height) // normalise mouse
        let closest = CGPoint(x: norm.x*CGFloat(self.mapWidth), y: norm.y*CGFloat(self.mapHeight)) // remap to grid size
        let gridPos = CGPoint(x: cellSize * Int(closest.x), y: cellSize * Int(closest.y))
                 
        let tile = self.board?[Int(closest.x)][Int(closest.y)] as? blockNode
        
        let levEd = LevelEditor(nibName: "LevelEditor", bundle: Bundle.main)
        
        levEd.colours = self.colours
        
        if(tile?.name?.contains("Tile") ==  true){
            let pop = NSPopover()
            pop.contentSize = NSSize(width: 300, height: 64)
            pop.behavior = .transient
            pop.animates = true
            pop.contentViewController = levEd
            print("pop at \(mpos)")
            levEd.pop = pop
            levEd.selected = self.colours[tile?.colourIndex ?? 0]
            levEd.node = tile
            pop.show(relativeTo: NSRect(x: gridPos.x, y: gridPos.y,width: 10,height: 10), of: self.view!, preferredEdge: .minY)
        }
        
    }
    
    // MOUSE DOWNNNNNN
    override func mouseDown(with event: NSEvent) {

        self.click = true
        if(self.playMode == .play){
            print("begin")
            self.currentPath = CGMutablePath()
            let s = SKShapeNode(path: self.currentPath!)
            self.currentPathNode = s
            self.currentPathNode?.strokeColor = NSColor.white
            self.currentPathNode?.lineWidth = 3
            self.currentPathNode?.isAntialiased = true
            //self.currentPathNode?.glowWidth = 0
            self.currentPathNode?.lineCap = .round
            self.currentPathNode?.name = "Ink"
            
            self.scene?.addChild(self.currentPathNode!)
            
        }else{ // place block on grid 
            let mp = event.location(in: self)
            let shape = blockNode(rect: CGRect(x: 0, y: 0, width: cellSize, height: cellSize), cornerRadius: 4.0)
            //let d = CGFloat(self.cellSize/2)
            shape.name = "Tile \(self.tiles)"
            self.tiles+=1
            //shape.position = CGPoint(x:floor(mp.x)-d,y:floor(mp.y)-d)
            let norm = CGPoint(x:mp.x/self.size.width,y:mp.y/self.size.height) // normalise mouse
            let closest = CGPoint(x: norm.x*CGFloat(self.mapWidth), y: norm.y*CGFloat(self.mapHeight)) // remap to grid size
            let gridPos = CGPoint(x: cellSize * Int(closest.x), y: cellSize * Int(closest.y))
            shape.position = gridPos
            shape.addPhysicsBody()
            shape.setColorFromArray(colours: self.colours, index: 0)
            //shape.fillColor = self.colours[tiles%colours.count]
            shape.strokeColor = NSColor.darkGray
            self.board?[Int(closest.x)][Int(closest.y)] = shape
            print("place at \(shape.position)")
            self.scene?.addChild(shape)
        }
        
    }

    override func mouseUp(with event: NSEvent) {
        self.click = false
    }
    
    
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        case 0x23:
            
            if(self.playMode == .play){
                self.playMode = .pause
            }else{ self.playMode = .play }
            
            
        case 0x1:
            self.saveMap()
            
//            let rep = NSBitmapImageRep(cgImage: self.lastImage!)
//
//
//
//                //rep.getPixel(po, atX: Int(self.balls[0].position.x), y: Int(self.balls[0].position.y))
//
//
//            for y in (0..<Int(self.size.height)) {
//                for x in (0..<Int(self.size.width)) {
//                    let po = UnsafeMutablePointer<Int>.allocate(capacity: 4 )
//                    rep.getPixel(po, atX:x, y: y)
//                    var RGBA = Array(UnsafeBufferPointer(start: po, count: 4))
//                    print(RGBA)
//                }
//            }
            
        case 0x8:
            self.clearInk()
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func touchesBegan(with event: NSEvent) {
        if(self.playMode == .play){
  
        self.touchedNode.run(fadeIn)
        let touches = event.touches(for: self.view!)
       
        
        
       
        for t in touches{
            
            let p = CGPoint(x: t.normalizedPosition.x * (self.scene?.size.width)!,
                            y: t.normalizedPosition.y * (self.scene?.size.height)!)
            if(self.currentPath != nil){
                print("move")
                self.currentPath?.move(to: p)
            }
            self.touchedNode.position = p
        }
        
        CGAssociateMouseAndMouseCursorPosition(0);
        CGDisplayHideCursor(kCGNullDirectDisplay);
        }
    }
    
    var lastImage:CGImage?
    override func touchesMoved(with event: NSEvent) {
        
        if(self.playMode == .play){
            let touches = event.touches(for: self.view!)
            for t in touches{
                
                let p = CGPoint(x: t.normalizedPosition.x * (self.scene?.size.width)!,
                                y: t.normalizedPosition.y * (self.scene?.size.height)!)
                if(self.click){
                    self.currentPath?.addLine(to: p)
                    self.currentPath?.move(to: p)
                    self.currentPathNode?.path = self.currentPath
                    
                    
                    
                    
                    let context = CGContext(data: nil,width: Int(self.size.width),height: Int(self.size.height),bitsPerComponent: 8,bytesPerRow: 0,space: CGColorSpaceCreateDeviceRGB(),bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
                    
                    context?.setStrokeColor(CGColor.black)
                    context?.setLineWidth(4.0)
                    context?.addPath(self.currentPath!)
                    context?.strokePath()
                    let image = context?.makeImage()
                    self.lastImage = image
                    
                    
                }
                
                self.touchedNode.position = p
            }
        }
    }
    
    override func touchesEnded(with event: NSEvent) {
        
        if(self.playMode == .play){
        CGDisplayShowCursor (kCGNullDirectDisplay);
        CGAssociateMouseAndMouseCursorPosition(1);
        self.touchedNode.run(fadeOut)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //self.balls[0].physicsBody?.applyForce(CGVector(dx: 1, dy: 1))
        
        if(self.lastImage != nil){
            
            let rep = NSBitmapImageRep(cgImage: self.lastImage!)
            let po = UnsafeMutablePointer<Int>.allocate(capacity: 4 )
            
            let bx = Int(self.balls[0].position.x)
            let by = Int(self.balls[0].position.y)
            
            for y in (0..<(self.cellSize)){
                for x in (0..<(self.cellSize)){
                    
                    let n = SKShapeNode(rectOf: CGSize(width: 4, height: 4))
                    n.position = CGPoint(x: bx+x, y: by+y)
                    //self.scene?.addChild(n)
                    rep.getPixel(po, atX: bx+x, y: Int(self.size.height)-(by+y))
                     let RGBA = Array(UnsafeBufferPointer(start: po, count: 4))
                    
                    //print(RGBA)
                     if (RGBA[3] > 0 ){
                         print("Hit! at \(x+bx) : \(y+by)")
                     }
                    
                }
            }
            
        }
        
        
    }
}
