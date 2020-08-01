//
//  LCDView.swift
//  inkballTest
//
//  Created by Connor Aspinall on 28/07/2020.
//

import SwiftUI

struct LCDView: View {
    
    var size:NSSize?
    var body: some View {
    
        ZStack{
            Rectangle().foregroundColor(Color(NSColor.controlBackgroundColor))
            HStack{ Text("Game ready") }
        }
    }
}

struct LCDView_Previews: PreviewProvider {
    static var previews: some View {
        LCDView()
    }
}
