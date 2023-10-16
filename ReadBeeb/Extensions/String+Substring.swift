//
//  String+Substring.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import Foundation

extension String {

    func substring(from startIndex: Int, to endIndex: Int) -> String {
        // Prevent accessing an index out of bounds
        var safeEndIndex = endIndex
        if endIndex >= self.count {
            safeEndIndex = self.count - 1
        }

        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: safeEndIndex)

        return String(self[start..<end])
    }

}
