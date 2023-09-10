//
//  TextContainer.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI

struct TextContainer: View {

    let container: FDTextContainer

    var body: some View {
        Text(self.container.text.text)
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
    }

}

struct TextContainer_Previews: PreviewProvider {
    static var previews: some View {
        TextContainer(container: FDTextContainer(type: "textContainer", containerType: "body", text: FDTextContainerText(text: "Test", spans: [])))
    }
}
