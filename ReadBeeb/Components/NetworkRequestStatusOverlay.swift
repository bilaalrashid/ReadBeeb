//
//  NetworkRequestStatusOverlay.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 15/10/2023.
//

import SwiftUI

struct NetworkRequestStatusOverlay: View {
    let networkRequest: NetworkRequestStatus
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
                EmptyView()
            }
        }
    }
}

#Preview {
    NetworkRequestStatusOverlay(networkRequest: .notStarted, isEmpty: true)
}
