//
//  RoundedCornerView.swift
//  CommonUI
//
//  Created by Emad Habib on 11/11/2024.
//

import UIKit

@IBDesignable
open class RoundedCornerView: UIView {

    // 1. Corner Radius Property
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
    // 2. Border Width Property (Optional)
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    // 3. Border Color Property (Optional)
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    // 4. Shadow Properties (Optional)
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            self.layer.shadowColor = shadowColor?.cgColor
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 4 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    // This ensures the customizations apply to the view
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
    }
}
