//
//  Appearance+Uitls.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import UIKit

extension UINavigationController {
  func setupNavBarAppearance() {
    // Used to set appearances on the global scene delegate
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    
    appearance.backgroundColor = .white.withAlphaComponent(1.0)
    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    
    self.navigationBar.standardAppearance = appearance
    self.navigationBar.scrollEdgeAppearance = appearance
    self.navigationBar.compactAppearance = appearance
    
    self.navigationBar.tintColor = .clear
    UIBarButtonItem.appearance().tintColor = .purple
  }
}
