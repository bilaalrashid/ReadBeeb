//
//  ImageDetailScreen.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 06/11/2023.
//

import SwiftUI
import LazyPager

struct ImageDetailScreen: View {
    let images: [FDImage]

    @Environment(\.dismiss) var dismiss
    @State private var opacity: CGFloat = 1
    @State private var index: Int
    @State private var isShowingControls = true

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
            print("hi")
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
