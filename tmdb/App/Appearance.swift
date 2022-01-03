//
//  Appearance.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/3/22.
//

import Foundation
import UIKit


final class Appearance {
    
    static func setupAppearance() {
        //navbar appearence
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProRounded-Bold", size: 15)!]
        navBarAppearance.barTintColor = .white
        navBarAppearance.tintColor = .black
        navBarAppearance.isTranslucent = true       
    }
}
