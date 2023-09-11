//
//  TextContainer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI

struct TextContainer: View {

    let container: FDTextContainer

    @State private var isLinkActive = false
    @State private var destination: FDLinkDestination? = nil {
        didSet {
            self.isLinkActive = true
        }
    }

    var body: some View {
        ZStack {
            Text(self.textFormattedSpans())
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .modify {
                    switch self.container.containerType {
                    case "body":
                        $0.font(.body)
                    case "crosshead":
                        $0.font(.title3.bold())
                    default:
                        $0.font(.body)
                    }
                }
                .environment(\.openURL, OpenURLAction { url in
                    if let destination = self.destination(for: url) {
                        self.destination = destination
                    }

                    return .handled
                })
                .navigationDestination(isPresented: self.$isLinkActive) {
                    if let destination = self.destination {
                        StoryDetailView(destination: destination)
                    }
                }
        }
    }

    private func textFormattedSpans() -> AttributedString {
        let spans = self.container.text.spans.sorted { $0.startIndex < $1.startIndex }
        let text = self.container.text.text

        var formatted = AttributedString()
        var lastIndex = 0

        for span in spans {
            let nextPlainSection = text.substring(from: lastIndex, to: span.startIndex)
            formatted += AttributedString(nextPlainSection)

            let extracted = text.substring(from: span.startIndex, to: span.startIndex + span.length)

            if let url = span.link.destinations.first?.url {
                var link = AttributedString(extracted)
                link.link = URL(string: url)
                formatted += link
            } else {
                formatted += AttributedString(extracted)
            }

            lastIndex = span.startIndex + span.length
        }

        let lastPlainSection = text.substring(from: lastIndex, to: text.count)
        formatted += AttributedString(lastPlainSection)

        return formatted
    }

    private func destination(for url: URL) -> FDLinkDestination? {
        var destinations = [FDLinkDestination]()
        self.container.text.spans.forEach {
            destinations.append(contentsOf: $0.link.destinations)
        }

        return destinations.first {
            $0.url == url.absoluteString
        }
    }

}

struct TextContainer_Previews: PreviewProvider {
    static var previews: some View {
        TextContainer(container: FDTextContainer(type: "textContainer", containerType: "body", text: FDTextContainerText(text: "Test", spans: [])))
    }
}
