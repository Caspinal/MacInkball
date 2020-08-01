//
//  ColourPalette.swift
//  inkballTest
//
//  Created by Connor Aspinall on 27/07/2020.
//

import SwiftUI


struct ColourItem:View{
    
    var colours:[NSColor]? = [.systemBlue,.systemPurple,.systemPink,.systemRed,.systemOrange,.systemYellow,.systemGreen,.systemGray]
    
    var body: some View{
        HStack{
            ForEach(self.colours!, id: \.self) { c in
                Rectangle().frame(width: 24, height: 24, alignment: .trailing).foregroundColor(Color(c))
            }
        }
    }
    
}


struct ColourPalette: View {
    var body: some View {
        List{
            ForEach(0..<10){ i in
                ColourItem()
            }
        }
    }
}

struct ColourPalette_Previews: PreviewProvider {
    static var previews: some View {
        ColourPalette()
    }
}
