//
//  NetworkRequestStatus.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 23/09/2023.
//

import Foundation

/// A data structure representing the status of an ongoing network request.
enum NetworkRequestStatus {
    /// The network request has not been started yet.
    case notStarted

    /// An error occurred during the network request.
    case error

    /// The network request is currently loading.
    case loading

    /// The network request was a result.
    case success
}
