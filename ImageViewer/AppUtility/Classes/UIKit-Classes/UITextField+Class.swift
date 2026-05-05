//
//  UITextField+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

class ThemeTextField: TextFieldPedding {
    private var padding: UIEdgeInsets = UIEdgeInsets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        padding = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 16)
        self.layer.cornerRadius = 9
        self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.font = UIFont.customFont(ofType: .regular, withSize: 14)
        self.placeHolderColor = #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}

class TextFieldPedding: UITextField {
    @IBInspectable var leftPadding : CGFloat = 20
    @IBInspectable var rightPadding : CGFloat = 20
    
    private var padding: UIEdgeInsets = UIEdgeInsets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Bundle.main.isArabicLanguage {
            padding = UIEdgeInsets(top: 0, left: rightPadding, bottom: 0, right: leftPadding)
        } else {
            padding = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding)
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 30, y: 0, width: 20 , height: bounds.height)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: 0, width: 20 , height: bounds.height)
    }
}

//dont select action in textfield
class RestrictionTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.autocorrectionType = .no
    }
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    //    override func caretRect(for position: UITextPosition) -> CGRect {
    //        return CGRect.zero
    //    }
    
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)){
            return false
        }
        else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}

class OTPTextField: UITextField {
    //    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.borderColor(color: #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1), borderWidth: 1.4)
        self.borderStyle = .none
        self.layer.cornerRadius = 8
        self.keyboardType = .asciiCapableNumberPad
        self.isSecureTextEntry = false
        self.textColor = #colorLiteral(red: 0.1490196078, green: 0.2078431373, blue: 0.2509803922, alpha: 1)
        self.font =  UIFont.customFont(ofType: .medium, withSize: 16)
        self.textAlignment = .center
        self.placeholder = "\u{2022}"
        self.delegate = self
        self.addTarget(self, action: #selector(textfieldIsEditing(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(textfieldIsEditing(_:)), for: .editingChanged)
    }
    //
    //    override open func textRect(forBounds bounds: CGRect) -> CGRect {
    //        return bounds.inset(by: padding)
    //    }
    //
    //    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    //        return bounds.inset(by: padding)
    //    }
    //
    //    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    //        return bounds.inset(by: padding)
    //    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("--------------------------------")
        if string.isEmpty {
            return true
        }
        if textField.text?.count == 1{
            textField.text = ""
            return true && string.isValid(.number)
        }
        print("--------------------------------")
        return true && string.isValid(.number)
    }
    
    @objc func textfieldIsEditing(_ textField:UITextField){
        if !textField.text!.isEmpty{
            if IQKeyboardManager.shared.canGoNext{
                IQKeyboardManager.shared.goNext()
            } else {
                self.resignFirstResponder()
            }
        }
    }
    override func deleteBackward() {
        super.deleteBackward()
        if IQKeyboardManager.shared.canGoPrevious{
            IQKeyboardManager.shared.goPrevious()
        }
    }
}
