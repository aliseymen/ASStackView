//
//  ExampleView.swift
//  ASStackView_Example
//
//  Created by Ali Seymen on 6.12.2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ExampleView: UIView {

    @objc @IBInspectable public var title: String = "" {
        didSet {
            labelTitle.text = title
        }
    }
    
    lazy var backgroundImageView : UIImageView = {
        let imgview = UIImageView()
        imgview.contentMode = .scaleAspectFill
        imgview.backgroundColor = UIColor.random()
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.94
        blurEffectView.frame = imgview.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgview.addSubview(blurEffectView)
        
        return imgview
    }()
    
    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.lineBreakMode = .byTruncatingTail
        let font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 30)!
        label.font = font
        label.minimumScaleFactor = 0.1
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.4
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        return label
    }()
    
    
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setup()
    }
    
    open func setup()
    {
        self.layer.masksToBounds = true
        addSubview(backgroundImageView)
        addSubview(labelTitle)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        
        labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        labelTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        labelTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
     }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

