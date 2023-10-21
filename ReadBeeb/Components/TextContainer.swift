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

    @State private var internalDestination: FDLinkDestination? = nil
    @State private var externalUrl: URL? = nil

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
            if url.isBBC, let destination = self.destination(for: url) {
                self.internalDestination = destination
            } else {
                self.externalUrl = url
            }

            return .handled
        })
        .navigationDestination(item: self.$internalDestination) { destination in
            DestinationDetailView(destination: destination)
        }
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

#Preview {
    VStack {
        TextContainer(
            container: FDTextContainer(
                type: "textContainer",
                containerType: "body",
                text: FDTextContainerText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In scelerisque imperdiet gravida. Nunc quis erat id ipsum egestas mollis. Etiam eleifend sit amet ipsum sit amet sollicitudin. Morbi ut venenatis ligula.", spans: [
                    FDTextContainerSpan(type: "emphasis", startIndex: 5, length: 10, attribute: "bold", link: nil),
                    FDTextContainerSpan(type: "emphasis", startIndex: 5, length: 15, attribute: "italic", link: nil),
                    FDTextContainerSpan(type: "link", startIndex: 5, length: 20, attribute: nil, link: FDLink(destinations: [
                        FDLinkDestination(sourceFormat: "abl", url: "http://bilaal.co.uk", id: "", presentation: FDPresentation(type: "", title: nil, canShare: nil))
                    ]))
                ])
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
