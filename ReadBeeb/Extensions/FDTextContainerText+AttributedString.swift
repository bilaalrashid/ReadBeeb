//
//  FDTextContainerText+AttributedString.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 19/10/2023.
//

import Foundation
import SwiftUI

extension FDTextContainerText {
    /// Returns an `AttributedString` representing the `FDTextContainerText` instance
    var attributedString: AttributedString {
        let attributedString = NSMutableAttributedString(string: self.text)

        for span in self.spans {
            let range = NSRange(location: span.startIndex, length: span.length)

            switch span.type {
            case "link":
                self.applyLinkAttributes(for: attributedString, span: span, range: range)
            case "emphasis":
                self.applyEmphasisAttributes(for: attributedString, span: span, range: range)
            default:
                break
            }
        }

        return AttributedString(attributedString)
    }

    private func applyLinkAttributes(for attributedString: NSMutableAttributedString, span: FDTextContainerSpan, range: NSRange) {
        if let url = span.link?.destinations.first?.url {
            let linkAttributes: [NSAttributedString.Key: Any] = [
                .link: url,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            attributedString.addAttributes(linkAttributes, range: range)
        }
    }

    private func applyEmphasisAttributes(for attributedString: NSMutableAttributedString, span: FDTextContainerSpan, range: NSRange) {
        let boldFont = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        let italicFont = UIFont.italicSystemFont(ofSize: UIFont.labelFontSize)
        let combinedFontDescriptor = UIFont.preferredFont(forTextStyle: .body).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic])
        let combinedFont = UIFont(descriptor: combinedFontDescriptor!, size: UIFont.labelFontSize)

        // BUG: If there are multiple attributes defined for the .font key over the same range, we have to show
        //      both, otherwise one will overwrite the other. This has a side-effect of overwriting all of the
        //      ranges to be the same. This is likely to be an extremely rare edge case in production, likely only
        //      occurring due to a formatting mistake (which this would fix), so this edge-case is permissible
        if attributedString.attribute(.font, at: range.location, effectiveRange: nil) != nil {
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
    }
}
