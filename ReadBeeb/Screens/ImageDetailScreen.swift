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
    @State var opacity: CGFloat = 1
    @State var index = 0

    var body: some View {
        LazyPager(data: self.images, page: self.$index) { image in
            ImageView(image: image, imageOnly: true)
        }
        .zoomable(min: 1, max: 5)
        .onDismiss(backgroundOpacity: self.$opacity) {
            self.dismiss()
        }
        .background(.black)
        .background(ClearFullScreenBackground())
        .opacity(self.opacity)
        .ignoresSafeArea()
        .overlay(VStack {
            HStack {
                Spacer()
                Button("Done") {
                    self.dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            }
            .opacity(self.opacity)
            Spacer()
        })
    }
}
