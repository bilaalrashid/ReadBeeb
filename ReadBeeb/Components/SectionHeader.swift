//
//  SectionHeader.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI

struct SectionHeader: View {
    let header: FDSectionHeader

    var body: some View {
        Text(header.text)
            .font(.headline.bold())
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(header: FDSectionHeader(type: "SectionHeader", text: "Header"))
    }
}
