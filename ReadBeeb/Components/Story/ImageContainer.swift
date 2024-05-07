//
//  ImageContainer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 07/05/2024.
//

import SwiftUI
import BbcNews

/// A container view for an image.
struct ImageContainer: View {
    /// The image container to display.
    let imageContainer: FDImageContainer

    var body: some View {
        ImageView(image: self.imageContainer.image)
    }
}
