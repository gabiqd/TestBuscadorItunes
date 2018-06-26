//
//  BaseNavigationViewController.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 21/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.primaryColor
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.navigationBar.isTranslucent = false
    }
}
