//
//  ImageDetailScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 06/11/2023.
//

import SwiftUI
import LazyPager
import BbcNews

/// The detail screen that displays images for viewing.
struct ImageDetailScreen: View {
    /// The images to display.
    let images: [FDImage]

    /// An action that dismisses the current presentation.
    @Environment(\.dismiss) var dismiss

    /// The opacity of the screen.
    @State private var opacity: CGFloat = 1

    /// The index of the image to be displayed in full.
    @State private var index: Int

    /// If the controls should be displayed to the user.
    @State private var isShowingControls = true

    /// Creates a new detail screen for displaying images.
    ///
    /// - Parameters:
    ///   - images: The images to display.
    ///   - initialIndex: The index of the first image to display.
    init(images: [FDImage], index initialIndex: Int) {
        self.images = images
        self._index = State(initialValue: initialIndex)
    }

    var body: some View {
        LazyPager(data: self.images, page: self.$index) { image in
            ImageView(image: image, imageOnly: true)
        }
        .zoomable(min: 1, max: 5)
        .onDismiss(backgroundOpacity: self.$opacity) {
            self.dismiss()
        }
        .onTap {
            self.isShowingControls.toggle()
        }
        .background(.black)
        .background(ClearFullScreenBackground())
        .opacity(self.opacity)
        .ignoresSafeArea()
        .overlay(
            VStack {
                if self.isShowingControls {
                    HStack {
                        Spacer()
                        Button("Done") {
                            self.dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                    }
                    .background(
                        Rectangle()
                            .fill(.black)
                            .opacity(0.4)
                            .background(Material.thinMaterial)
                            .environment(\.colorScheme, .dark)
                            .edgesIgnoringSafeArea(.top)
                    )
                    .opacity(self.opacity)
                }
                Spacer()
            }
        )
    }
}
