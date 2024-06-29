//
//  NetworkRequestStatusOverlay.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import SwiftUI

/// A view that displays an overlay to indicate the current state of a network request.
struct NetworkRequestStatusOverlay: View {
    /// The state of the network request.
    let networkRequest: NetworkRequestStatus

    /// If the network request returned an empty result.
    let isEmpty: Bool

    var body: some View {
        Group {
            switch self.networkRequest {
            case .loading, .notStarted:
                if self.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView()
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }
            case .error:
                Text("Unable to load data. Please try again later and get in contact if the problem persists.")
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            case .success:
                if self.isEmpty {
                    Text("Unable to load data. Please try again later and get in contact if the problem persists.")
                        .padding()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    NetworkRequestStatusOverlay(networkRequest: .notStarted, isEmpty: true)
}
