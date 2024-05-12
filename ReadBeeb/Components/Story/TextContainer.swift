//
//  TextContainer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI
import BbcNews

struct TextContainer: View {
    let container: FDTextContainer
    var list: FDContentList?
    /// If the item is part of the list, the index of the item in the list, zero-indexed
    var index: Int?

    /// A destination that the text container can link to e.g. another story.
    @Binding var destination: FDLinkDestination?

    @State private var externalUrl: URL?

    var body: some View {
        HStack(alignment: .top) {
            if let list = self.list {
                if let index = self.index, list.ordering == "ORDERED" {
                    // The list is zero-index
                    Text("\(index + 1).")
                } else {
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundStyle(Color.primary)
                        .padding(.top, 8)
                }
            }

            Text(self.container.text.attributedString)
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
            // swiftlint:disable:next force_https
            let schemesToHandle = ["http", "https"]
            guard let scheme = url.scheme else { return .systemAction }

            if schemesToHandle.contains(scheme) {
                if url.isBBC, let destination = self.destination(for: url) {
                    self.destination = destination
                } else {
                    self.externalUrl = url
                }

                return .handled
            } else {
                // Let the system handle non-web schemes e.g. mailto: or tel:
                return .systemAction
            }
        })
        .fullScreenCover(item: self.$externalUrl) { url in
            SafariView(url: url)
                .ignoresSafeArea()
        }
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

// swiftlint:disable line_length
#Preview {
    VStack {
        TextContainer(
            container: FDTextContainer(
                containerType: "body",
                text: FDTextContainerText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In scelerisque imperdiet gravida. Nunc quis erat id ipsum egestas mollis. Etiam eleifend sit amet ipsum sit amet sollicitudin. Morbi ut venenatis ligula.", spans: [
                    FDTextContainerSpan(type: "emphasis", startIndex: 5, length: 10, attribute: "bold", link: nil),
                    FDTextContainerSpan(type: "emphasis", startIndex: 5, length: 15, attribute: "italic", link: nil),
                    FDTextContainerSpan(type: "link", startIndex: 5, length: 20, attribute: nil, link: FDLink(destinations: [
                        FDLinkDestination(sourceFormat: "abl", url: "https://bilaal.co.uk", id: "", presentation: FDPresentation(type: "", title: nil, canShare: nil))
                    ]))
                ])
            ), destination: .constant(nil)
        )
        TextContainer(
            container: FDTextContainer(
                containerType: "body",
                text: FDTextContainerText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In scelerisque imperdiet gravida. Nunc quis erat id ipsum egestas mollis. Etiam eleifend sit amet ipsum sit amet sollicitudin. Morbi ut venenatis ligula.", spans: [])
            ),
            list: FDContentList(ordering: "UNORDERED", listItems: []),
            destination: .constant(nil)
        )
        TextContainer(
            container: FDTextContainer(
                containerType: "introduction",
                text: FDTextContainerText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In scelerisque imperdiet gravida. Nunc quis erat id ipsum egestas mollis. Etiam eleifend sit amet ipsum sit amet sollicitudin. Morbi ut venenatis ligula.", spans: [])
            ),
            list: FDContentList(ordering: "ORDERED", listItems: []),
            index: 1,
            destination: .constant(nil)
        )
        TextContainer(
            container: FDTextContainer(
                containerType: "crosshead",
                text: FDTextContainerText(text: "A Title Here", spans: [])
            ),
            destination: .constant(nil)
        )
    }
}
// swiftlint:enable line_length
