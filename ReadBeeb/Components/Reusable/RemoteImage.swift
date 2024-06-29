//
//  RemoteImage.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI
import Kingfisher

/// A view that displays an image stored on a remote server.
struct RemoteImage: View {
    /// The URL of the image to display.
    let url: URL?

    /// A URL of an alternative image to use when the client device is in low data mode.
    let lowDataUrl: URL?

    var body: some View {
        GeometryReader { geo in
            KFImage(self.url)
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                .resizable()
                .modify {
                    if let url = self.lowDataUrl {
                        $0.lowDataModeSource(.network(url))
                    } else {
                        $0
                    }
                }
                .scaledToFit()
        }
    }
}

#Preview {
    RemoteImage(url: nil, lowDataUrl: nil)
}
