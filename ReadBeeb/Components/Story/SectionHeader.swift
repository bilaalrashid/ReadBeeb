//
//  SectionHeader.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI
import BbcNews

struct SectionHeader: View {
    let header: FDSectionHeader

    var body: some View {
        Text(self.header.text)
            .font(.title3.bold())
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(header: FDSectionHeader(type: "SectionHeader", text: "Header"))
    }
}
