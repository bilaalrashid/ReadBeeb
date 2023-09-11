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

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: StoryWebView

        init(_ parent: StoryWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let css = "#cookiePrompt, .bbccookies-banner, #orbit-header, .orbit-header-container, header, #u47640082145343365, .nav-top, #core-navigation, #services-bar, #orb-footer, .orb-footer { display: none; }"
            let js = "const style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"

            webView.evaluateJavaScript(js)
        }
    }

}
