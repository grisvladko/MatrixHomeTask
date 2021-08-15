//
//  Extensions.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

extension UIView {
    func pin(_ view: UIView, insets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -insets.bottom),
            view.leadingAnchor.constraint(equalTo: leadingAnchor,constant: insets.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -insets.right)
        ])
    }
    
    func clean() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func setShadow(radius: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.0
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.masksToBounds = false
    }
    
    func hideShadow() {
        layer.shadowOpacity = 0.0
    }
    
    func showShadow() {
        layer.shadowOpacity = 1.0
    }
}

extension UIColor {
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return .init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static let goldenTitle = UIColor.rgba(212, 150, 6, 1)
    static let tabButtonSelected = UIColor.rgba(71, 122, 167, 1.0)
    static let tabButtonUnselected = UIColor.rgba(50, 50, 50, 1.0)
}

extension UILabel {
    func setOutline(with text: String, color: UIColor, strokeWidth: CGFloat) {
        
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.black,
            .foregroundColor : color,
            .strokeWidth : strokeWidth,
        ]
        
        attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
    }
}

extension String {
    
    func withBoldText(text: String, boldTextFont: UIFont? = nil) -> NSAttributedString {
        let _font = boldTextFont ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }
    
}
