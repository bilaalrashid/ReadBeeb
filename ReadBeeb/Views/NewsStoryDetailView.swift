//
//  NewsStoryDetailView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/09/2023.
//

import SwiftUI

struct NewsStoryDetailView: View {

    let destination: BBCNewsAPIFDFluffyDestination

    var body: some View {
        Text("Hello, World!")
    }
    
}

struct NewsStoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsStoryDetailView(destination:
                                BBCNewsAPIFDFluffyDestination(
                                    sourceFormat: .abl,
                                    url: "https://news-app.api.bbc.co.uk/fd/abl?clientName=Chrysalis&page=world-europe-66631182&service=news&type=asset",
                                    id: "/news/world-europe-66631182",
                                    presentation: BBCNewsAPIFDFluffyPresentation(
                                        type: .singleRenderer,
                                        canShare: true,
                                        focusedItemIndex: nil,
                                        contentSource: nil,
                                        title: nil
                                    )
                                )
        )
    }
}
