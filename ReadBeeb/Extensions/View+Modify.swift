//
//  View+Modify.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 10/09/2023.
//

import SwiftUI

extension View {
    /// Allows additional logic to view modifier.
    ///
    /// Example usage:
    /// ```
    /// struct ContentView: View {
    ///    var body: some View {
    ///        Text("Hello, world!")
    ///            .modify {
    ///                if #available(iOS 14, *) {
    ///                    $0.textCase(.uppercase)
    ///                } else {
    ///                    $0 // iOS 13 fallback
    ///                }
    ///            }
    ///    }
    /// }
    /// ```
    func modify<T: View>(@ViewBuilder _ modifier: (Self) -> T) -> some View {
        return modifier(self)
    }
}
