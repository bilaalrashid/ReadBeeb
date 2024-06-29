//
//  Copyright.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 24/09/2023.
//

import SwiftUI
import BbcNews

/// A view that displays a BBC copyright disclaimer.
struct Copyright: View {
    /// The details of the copyright disclaimer to display.
    let item: FDCopyright

    /// The year to display in the copyright disclaimer.
    private var year: Int? {
        let components = Calendar.autoupdatingCurrent.dateComponents([.year], from: self.item.lastUpdated)
        return components.year
    }

    var body: some View {
        Text(verbatim: "Copyright © \(self.year ?? 0) BBC")
            .font(.callout)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(16)
    }
}

#Preview {
    Copyright(item: FDCopyright(lastUpdated: Date()))
}
