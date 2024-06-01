//
//  View+Frame.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 01/06/2024.
//

import SwiftUI

extension View {
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width or height,
    /// calculating the other value based on the aspect ratio.
    ///
    /// For example, the following code lays out a rectangle in a fixed with a
    /// height of 200, and an aspect ratio of 1.5, giving a resulting width of
    /// 300.
    ///
    ///     Rectangle()
    ///         .fill(Color.purple)
    ///         .frame(height: 200, aspectRatio: 1.5)
    ///
    /// The `alignment` parameter specifies this view's alignment within the
    /// frame.
    ///
    ///     Text("Hello world!")
    ///         .frame(height: 200, aspectRatio: 1.5, alignment: .topLeading)
    ///         .border(Color.gray)
    ///
    /// In the example above, the text is positioned at the top, leading corner
    /// of the frame. If the text is taller than the frame, its bounds may
    /// extend beyond the bottom of the frame's bounds.
    ///
    /// - Parameters:
    ///   - width: A fixed width for the resulting view.
    ///   - aspectRatio: The aspect ratio of the frame, which is used to calculate
    ///     the height of the resulting view.
    ///   - alignment: The alignment of this view inside the resulting frame.
    ///     Note that most alignment values have no apparent effect when the
    ///     size of the frame happens to match that of this view.
    ///
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    func frame(width: CGFloat, aspectRatio: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: width, height: width / aspectRatio, alignment: alignment)
    }

    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width or height,
    /// calculating the other value based on the aspect ratio.
    ///
    /// For example, the following code lays out a rectangle in a fixed with a
    /// height of 200, and an aspect ratio of 1.5, giving a resulting width of
    /// 300.
    ///
    ///     Rectangle()
    ///         .fill(Color.purple)
    ///         .frame(height: 200, aspectRatio: 1.5)
    ///
    /// The `alignment` parameter specifies this view's alignment within the
    /// frame.
    ///
    ///     Text("Hello world!")
    ///         .frame(height: 200, aspectRatio: 1.5, alignment: .topLeading)
    ///         .border(Color.gray)
    ///
    /// In the example above, the text is positioned at the top, leading corner
    /// of the frame. If the text is taller than the frame, its bounds may
    /// extend beyond the bottom of the frame's bounds.
    ///
    /// - Parameters:
    ///   - height: A fixed height for the resulting view.
    ///   - aspectRatio: The aspect ratio of the frame, which is used to calculate
    ///     the width of the resulting view.
    ///   - alignment: The alignment of this view inside the resulting frame.
    ///     Note that most alignment values have no apparent effect when the
    ///     size of the frame happens to match that of this view.
    ///
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    func frame(height: CGFloat, aspectRatio: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: height * aspectRatio, height: height, alignment: alignment)
    }
}
