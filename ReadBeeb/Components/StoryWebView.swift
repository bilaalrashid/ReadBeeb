//
//  StoryWebView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import SwiftUI
import WebKit

struct StoryWebView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

}
