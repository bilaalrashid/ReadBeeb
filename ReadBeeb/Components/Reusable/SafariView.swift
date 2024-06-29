//
//  SafariView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 21/10/2023.
//

import Foundation
import SwiftUI
import SafariServices

/// A view that wraps `SFSafariViewController` using `UIViewControllerRepresentable`.
struct SafariView: UIViewControllerRepresentable {
    /// The URL to display in the Safari view controller.
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        return
    }
}
