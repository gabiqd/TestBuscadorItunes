//
//  CustomButton.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 21/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    private let nonClickColor = UIColor.primaryColor
    private let clickColor = UIColor.primaryDarkColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = nonClickColor
        self.contentEdgeInsets = UIEdgeInsetsMake(12, 10, 12, 10);
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        self.layer.cornerRadius = 22
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? clickColor : nonClickColor
        }
    }
}
