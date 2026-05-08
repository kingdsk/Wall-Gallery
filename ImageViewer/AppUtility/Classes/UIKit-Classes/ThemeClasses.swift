// ThemeClasses.swift
// ImageViewer
//
// Custom IBOutlet-typed subclasses used by ProfileVC storyboard.

import UIKit

/// A styled UITextField with padding — used as IBOutlet type in ProfileVC.
class ThemeTextField: UITextField {
    private var padding: UIEdgeInsets = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 16)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 9
        self.textColor = .black
        self.font = UIFont.customFont(ofType: .regular, withSize: 14)
        self.backgroundColor = .white
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: padding) }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: padding) }
    override func editingRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: padding) }
}

/// A styled UIButton — used as IBOutlet type in ProfileVC.
class ThemeBlueButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font(name: .medium, size: 18)
            .textColor(color: .white)
            .backGroundColor(color: UIColor(red: 0.086, green: 0.380, blue: 0.678, alpha: 1))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius(cornerRadius: self.bounds.height / 2)
    }
}
