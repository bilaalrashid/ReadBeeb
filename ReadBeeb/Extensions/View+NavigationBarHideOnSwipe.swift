//
//  View+NavigationBarHideOnSwipe.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/11/2023.
//

import SwiftUI

extension View {

    func navigationBarsHideOnSwipe(_ hidesBarsOnSwipe: Bool, color: Color? = nil) -> some View {
        self.background(NavigationController { navigationController in
            navigationController.hidesBarsOnSwipe = hidesBarsOnSwipe
        })
        .modify {
            if let color = color {
                $0.overlay(alignment: .top) {
                    color
                        .ignoresSafeArea(edges: .top)
                    // Ensure it stays within the safe area only i.e. the status bar boundary
                        .frame(height: 0)
                }
            } else {
                $0
            }
        }
    }

}
