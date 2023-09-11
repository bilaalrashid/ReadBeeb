//
//  String+Substring.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 11/09/2023.
//

import Foundation

extension String {

    func substring(from startIndex: Int, to endIndex: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        return String(self[start..<end])
    }

}
