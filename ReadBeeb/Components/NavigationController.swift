//
//  NavigationController.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 03/11/2023.
//

import Foundation
import SwiftUI

struct NavigationController: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationController>) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = controller.navigationController {
                self.configure(navigationController)
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationController>) {
    }
}
