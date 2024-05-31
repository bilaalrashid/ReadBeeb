//
//  Copyright.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 24/09/2023.
//

import SwiftUI
import BbcNews

struct Copyright: View {
    let item: FDCopyright

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
