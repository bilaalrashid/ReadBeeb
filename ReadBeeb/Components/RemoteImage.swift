//
//  RemoteImage.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 22/10/2023.
//

import SwiftUI
import Kingfisher

struct RemoteImage: View {
    let url: URL?

    var body: some View {
        GeometryReader { geo in
            KFImage(self.url)
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    RemoteImage(url: nil)
}
