//
//  String+Substring.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import Foundation

extension String {

    func substring(from startIndex: Int, to endIndex: Int) -> String {
//        // TODO: - revert this patch
//        // ^ I think this is happening because the text has both bold and italic for example, so the logic when this is called is all wrong
//        if startIndex >= endIndex  {
//            return self
//        }

//        // Prevent accessing an index out of bounds
//        var safeEndIndex = endIndex
//        if endIndex >= self.count {
//            safeEndIndex = self.count - 1
//        }

        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: endIndex)

        return String(self[start..<end])
    }

}
