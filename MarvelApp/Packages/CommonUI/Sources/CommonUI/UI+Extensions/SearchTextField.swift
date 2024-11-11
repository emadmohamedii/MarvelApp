//
//  SearchTextField.swift
//  CommonUI
//
//  Created by Emad Habib on 11/11/2024.
//

import UIKit

open class SearchTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // Customize appearance
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.systemGray5
        
        // Placeholder and left padding
        self.placeholder = "Search"
        self.setLeftPadding(10)
        
        // Add search icon
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = UIColor.gray
        self.leftView = searchIcon
        self.leftViewMode = .always
    }
    
    // Method to add padding to the left of the text
    private func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
