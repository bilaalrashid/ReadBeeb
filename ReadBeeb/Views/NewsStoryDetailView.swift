//
//  NewsStoryDetailView.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/09/2023.
//

import SwiftUI

struct NewsStoryDetailView: View {

    let destination: BBCNewsAPIFederatedDiscoveryFluffyDestination

    var body: some View {
        Text("Hello, World!")
    }
    
}

struct NewsStoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsStoryDetailView(destination:
                                BBCNewsAPIFederatedDiscoveryFluffyDestination(
                                    sourceFormat: .abl,
                                    url: "https://news-app.api.bbc.co.uk/fd/abl?clientName=Chrysalis&page=world-europe-66631182&service=news&type=asset",
                                    id: "/news/world-europe-66631182",
                                    presentation: BBCNewsAPIFederatedDiscoveryFluffyPresentation(
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
