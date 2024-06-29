//
//  URL+ValueOf.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 16/10/2023.
//

import Foundation

extension URL {
    /// Returns the value of the query parameter in the URL, if it exists.
    ///
    /// - Parameter queryParameterName: The query parameter to get the value for
    /// - Returns: The value of the specified query parameter
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        let queryItem = url.queryItems?.first { $0.name == queryParameterName }
        return queryItem?.value
    }
}
