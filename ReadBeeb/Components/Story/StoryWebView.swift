//
//  StoryWebView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import SwiftUI
import WebKit

/// A view that wraps `WKWebView` using `UIViewRepresentable`.
struct StoryWebView: UIViewRepresentable {
    /// The URL to display in the web view.
    let url: URL

    /// The callback executed when the URL has finished loading in the web view.
    let didFinishLoading: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // noop
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: StoryWebView

        init(_ parent: StoryWebView) {
            self.parent = parent
        }

        // swiftlint:disable:next implicitly_unwrapped_optional
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            let unminifiedCss = """
                #cookiePrompt,
                .bbccookies-banner,
                #orbit-header,
                .orbit-header-container,
                header,
                #top-navigation,
                #u47640082145343365,
                .nav-top,
                #core-navigation,
                #services-bar,
                #orb-footer,
                .orb-footer,
                nav,
                [class$=\"GlobalNavigation\"],
                [class$=\"ConsentBanner\"],
                #features-label-aside-content,
                #elsewhere-label-aside-content,
                #footer-content,
                [data-testid=\"testoverlay\"],
                #header-content,
                .lx-commentary__top-link,
                .qa-bottom-navigation {
                    display: none;
                }
            """

            let css = unminifiedCss.replacingOccurrences(of: "\n", with: " ")
            let javascript = "const style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"

            self.parent.didFinishLoading()
            webView.evaluateJavaScript(javascript)
        }
    }
}
