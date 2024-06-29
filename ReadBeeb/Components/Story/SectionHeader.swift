//
//  SectionHeader.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI
import BbcNews

/// A view that displays the section header of a story.
struct SectionHeader: View {
    /// The section header to display.
    let header: FDSectionHeader

    var body: some View {
        Text(self.header.text)
            .font(.title3.bold())
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(header: FDSectionHeader(text: "Header"))
    }
}
