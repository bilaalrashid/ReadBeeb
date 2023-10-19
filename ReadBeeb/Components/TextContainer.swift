//
//  TextContainer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI

struct TextContainer: View {

    let container: FDTextContainer
    var list: FDContentList? = nil
    var index: Int? = nil

    @State private var isLinkActive = false
    @State private var destination: FDLinkDestination? = nil {
        didSet {
            self.isLinkActive = true
        }
    }

    var body: some View {
        HStack(alignment: .top) {
            if let list = self.list {
                if let index = self.index, list.ordering == "ORDERED" {
                    Text("\(index).")
                } else {
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundStyle(Color.primary)
                        .padding(.top, 8)
                }
            }

            Text(self.textFormattedSpans())
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .lineSpacing(4)
        .modify {
            switch self.container.containerType {
            case "body":
                $0.font(.body)
            case "introduction":
                $0.font(.headline)
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
                DestinationDetailView(destination: destination)
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

            if let url = span.link?.destinations.first?.url {
                var link = AttributedString(extracted)
                link.link = URL(string: url)
                formatted += link
            } else if let attribute = span.attribute {
                var container = AttributeContainer()
                container[AttributeScopes.SwiftUIAttributes.FontAttribute.self] = attribute == "bold" ? .body.bold() : .body.italic()
                formatted += AttributedString(extracted, attributes: container)
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
            if let link = $0.link {
                destinations.append(contentsOf: link.destinations)
            }
        }

        return destinations.first {
            $0.url == url.absoluteString
        }
    }

}

#Preview {
    VStack {
        TextContainer(
            container: FDTextContainer(
                type: "textContainer",
                containerType: "body",
                text: FDTextContainerText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In scelerisque imperdiet gravida. Nunc quis erat id ipsum egestas mollis. Etiam eleifend sit amet ipsum sit amet sollicitudin. Morbi ut venenatis ligula.", spans: [])
            )
        )
        TextContainer(
            container: FDTextContainer(
                type: "textContainer",
                containerType: "body",
                text: FDTextContainerText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In scelerisque imperdiet gravida. Nunc quis erat id ipsum egestas mollis. Etiam eleifend sit amet ipsum sit amet sollicitudin. Morbi ut venenatis ligula.", spans: [])
            ),
            list: FDContentList(type: "", ordering: "UNORDERED", listItems: [])
        )
        TextContainer(
            container: FDTextContainer(
                type: "textContainer",
                containerType: "introduction",
                text: FDTextContainerText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In scelerisque imperdiet gravida. Nunc quis erat id ipsum egestas mollis. Etiam eleifend sit amet ipsum sit amet sollicitudin. Morbi ut venenatis ligula.", spans: [])
            ),
            list: FDContentList(type: "", ordering: "ORDERED", listItems: []),
            index: 1
        )
        TextContainer(
            container: FDTextContainer(
                type: "textContainer",
                containerType: "crosshead", text: FDTextContainerText(text: "A Title Here", spans: [])
            )
        )
    }
}
