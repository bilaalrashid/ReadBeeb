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
        let attributedString = NSMutableAttributedString(string: self.container.text.text)

        for span in self.container.text.spans {
            let range = NSRange(location: span.startIndex, length: span.length)

            switch span.type {
            case "link":
                if let url = span.link?.destinations.first?.url {
                    let linkAttributes: [NSAttributedString.Key: Any] = [
                        .link: url,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ]
                    attributedString.addAttributes(linkAttributes, range: range)
                }
            case "emphasis":
                let boldFont = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
                let italicFont = UIFont.italicSystemFont(ofSize: UIFont.labelFontSize)
                let combinedFont = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .body).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic])!, size: UIFont.labelFontSize)

                // BUG: If there are multiple attributes defined for the .font key over the same range, we have to show
                //      both otherwise one will overwrite the other. This has a side-effect of overwriting all of the
                //      ranges to be the same. This is likely to be an extremely rare edge case in production, likely only
                //      occurring due to formatting mistake (which this would fix), so this edge-case is permissible
                if (attributedString.attribute(.font, at: range.location, effectiveRange: nil) != nil) {
                    attributedString.addAttribute(.font, value: combinedFont, range: range)
                } else {
                    switch span.attribute {
                    case "bold":
                        attributedString.addAttribute(.font, value: boldFont, range: range)
                    case "italic":
                        attributedString.addAttribute(.font, value: italicFont, range: range)
                    default:
                        break
                    }
                }
            default:
                break
            }
        }

        return AttributedString(attributedString)
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
