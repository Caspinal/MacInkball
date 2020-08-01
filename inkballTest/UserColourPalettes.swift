//
//  UserColourPalettes.swift
//  inkballTest
//
//  Created by Connor Aspinall on 27/07/2020.
//

import Foundation
import Cocoa


struct ColourPItem{
    
    var name:String?
    var colours:[NSColor]?

}


class UserColourPalettes{
    
    var Palettes:[ColourPItem] = []
    
    init() {
        let dp = ColourPItem(name: "Default", colours: [.systemBlue,.systemPurple,.systemPink,.systemRed,.systemOrange,.systemYellow,.systemGreen,.systemGray])
        
        self.Palettes.append(dp)
    }
    
}
