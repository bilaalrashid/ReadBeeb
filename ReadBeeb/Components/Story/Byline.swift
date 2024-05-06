//
//  Byline.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 06/05/2024.
//

import SwiftUI
import BbcNews

/// A view the displays a byline for a story.
struct Byline: View {
    /// The byline to display.
    let byline: FDByline

    var body: some View {
        VStack(spacing: 8) {
            ForEach(Array(self.byline.contributors.enumerated()), id: \.offset) { _, contributor in
                VStack(spacing: 4) {
                    Text(contributor.name)
                        .font(.callout.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text(contributor.role)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

#Preview {
    VStack {
        Byline(byline: FDByline(contributors: [
            FDBylineContributor(type: "Contributor", name: "Chris Mason", role: "Political Editor")
        ]))
        Divider()
        Byline(byline: FDByline(contributors: [
            FDBylineContributor(type: "Contributor", name: "Chris Mason", role: "Political Editor"),
            FDBylineContributor(type: "Contributor", name: "Laura Kuenssberg", role: "Sunday with Laura Kuenssberg")
        ]))
    }
}
