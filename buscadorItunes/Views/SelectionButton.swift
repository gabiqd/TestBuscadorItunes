//
//  SelectionButton.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 25/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation
import UIKit

class SelectionButton: UIButton {
    private let nonClickColor = UIColor.primaryColor
    private let clickColor = UIColor.secondaryColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = nonClickColor.cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(nonClickColor, for: .normal)
        self.setTitleColor(clickColor, for: .highlighted)
        self.setTitleColor(clickColor, for: .selected)
        self.titleLabel?.textColor = .black
        self.contentEdgeInsets = UIEdgeInsetsMake(8, 6, 8, 6);
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.layer.cornerRadius = 4
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = isSelected ? clickColor.cgColor : nonClickColor.cgColor
        }
    }
}
