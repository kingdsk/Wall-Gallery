//
//  UIButton+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

//Theme blue button
class ThemeBlueButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font(name: .medium, size: 18).textColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).backGroundColor(color: #colorLiteral(red: 0.0862745098, green: 0.3803921569, blue: 0.6784313725, alpha: 1))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius(cornerRadius: self.bounds.height / 2)
    }
}

class ThemeBlueRightIconButton: UIButton {
    
    ///Space between lable and text
    private var space: CGFloat = 8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.semanticContentAttribute = .forceLeftToRight
        self.font(name: .medium, size: 18).backGroundColor(color: #colorLiteral(red: 0.0862745098, green: 0.3803921569, blue: 0.6784313725, alpha: 1)).textColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), state: .none)
//        textColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    override func imageRect(forContentRect contentRect:CGRect) -> CGRect {
        var imageFrame = super.imageRect(forContentRect: contentRect)
        imageFrame.origin.x = super.titleRect(forContentRect: contentRect).maxX - imageFrame.width + space
        return imageFrame
    }
    
    override func titleRect(forContentRect contentRect:CGRect) -> CGRect {
        var titleFrame = super.titleRect(forContentRect: contentRect)
        if (self.currentImage != nil) {
            titleFrame.origin.x = super.imageRect(forContentRect: contentRect).minX - space
        }
        return titleFrame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius(cornerRadius: self.bounds.height / 2)
    }
}

//Social Login button
class SocialLoginButton: UIButton {
    
    ///Sets the text color
    @IBInspectable var textColor: UIColor? = UIColor.white {
        didSet {
            self.textColor(color: textColor ?? #colorLiteral(red: 0.0862745098, green: 0.3803921569, blue: 0.6784313725, alpha: 1))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.font(name: .medium, size: 14)
        self.setInsets(imageTitlePadding: 3)
        self.borderColor(color: #colorLiteral(red: 0.9450980392, green: 0.9529411765, blue: 0.9647058824, alpha: 1), borderWidth: 1)
        self.applyViewShadow(shadowOffset: CGSize(width: 0, height: 4), shadowColor: UIColor.black.withAlphaComponent(0.11), shadowOpacity: 1.0, shdowRadious: 8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
}

//Theme orange button
class ThemeOrangeButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font(name: .medium, size: 18).textColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).backGroundColor(color: #colorLiteral(red: 0.9098039216, green: 0.6980392157, blue: 0.2039215686, alpha: 1))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius(cornerRadius: self.bounds.height / 2)
    }
}

//Flip image button
class FlipImageButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        if Bundle.main.isArabicLanguage {
            self.setImage(self.currentImage?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
    }
}

//Right side icon button
class ButtonIconRight: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.semanticContentAttribute = .forceLeftToRight
    }
    override func imageRect(forContentRect contentRect:CGRect) -> CGRect {
        var imageFrame = super.imageRect(forContentRect: contentRect)
        imageFrame.origin.x = super.titleRect(forContentRect: contentRect).maxX - imageFrame.width
        return imageFrame
    }
    
    override func titleRect(forContentRect contentRect:CGRect) -> CGRect {
        var titleFrame = super.titleRect(forContentRect: contentRect)
        if (self.currentImage != nil) {
            titleFrame.origin.x = super.imageRect(forContentRect: contentRect).minX
        }
        return titleFrame
    }
}
