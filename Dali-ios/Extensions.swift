//
//  File.swift
//  Dali-ios
//
//  Created by Or Milis on 23/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFromUrl(urlString: String) {
        RestController.getNonJSON(urlString: urlString, completion: { ( res: Result<Data, Error>) in
            switch res {
            case .success(let genData):
                guard let image = UIImage(data: genData) else { return }
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func setRoundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}

extension UIButton {
    func setShadow(color: CGColor, offset: CGSize, opacity: Float, radius: CGFloat, mask: Bool = false) {
        self.layer.shadowColor = color
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = mask
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: (rgb) & 0xFF, a: a)
    }
}
