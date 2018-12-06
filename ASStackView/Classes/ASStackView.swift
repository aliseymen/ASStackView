//
//  ASCardsView.swift
//  mevlana365
//
//  Created by Ali Seymen on 16.11.2018.
//  Copyright © 2018 Ali Kesebi. All rights reserved.
//

import UIKit

open class ASStackView: UIControl {

    public var pageChanged : ((_ index : Int)->Void)?

    public var views : [UIView]! {
        didSet {
            if views != nil
            {
                setup()
            }
        }
    }
    
    private var currentViewInitialCenter: CGPoint!
    public var currentIndex: Int = 0 {
        didSet {
            if views != nil
            {
                if currentIndex == views.count
                {
                    currentIndex = 0
                }
            }
            else
            {
                stackIndex = currentIndex
            }
        }
    }
    private var stackIndex: Int = 0
    private var multiplier: Int = 0

    public var space: Int = 8
    public var cornerRadius: CGFloat = 8

    var nextIndex : Int {
        get {
            var i = currentIndex + 1
            if i == views.count
            {
                i = 0
            }
            
            return i
        }
    }
    
    var lastIndex : Int {
        get {
            let i = currentIndex + (totalCardInStack - 1)

            if i >= views.count
            {
                let val = i - views.count
                return val
            }
            
            return i
        }
    }
    
    var currentView : UIView {
        get {
            let v = views[currentIndex]
            v.isUserInteractionEnabled = true
            return v
        }
    }
    
    public var isInfinite : Bool = true
    public var totalCardInStack : Int = 3

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open func setup()
    {
        if subviews.count > 0
        {
            self.subviews.forEach({$0.removeFromSuperview()})
        }
        generateViews()
        addPanGestureTo(view : views[currentIndex])
    }
    
    func changeToIndex(_ index : Int)
    {
        currentIndex = index
        stackIndex = index
        self.pageChanged?(self.currentIndex)
        self.subviews.forEach({$0.removeFromSuperview()})
        generateViews()
    }
    
    func generateViews()
    {
        if views.count >= totalCardInStack
        {
            let loopCount = totalCardInStack - 1
            
            for index in stride(from: loopCount, to: -1, by: -1){
                var i = currentIndex + index
                if i >= views.count
                {
                    i = i - views.count
                }
                let v = views[i]
                setupConstraintsOf(view : v, index: index)
            }
        }
    }
    
    func setupConstraintsOf(view : UIView, index : Int, isAdditional : Bool = false)
    {
        view.layer.cornerRadius = cornerRadius
        view.isUserInteractionEnabled = false

        if index == 0
        {
            view.isUserInteractionEnabled = true
        }
        
        let i = totalCardInStack - (index + 1)
        let top = space * i
        let margin = -top + (space * (totalCardInStack - 1))
        
        self.addSubview(view)
        
        var sindex = currentIndex + index
        if sindex >= views.count
        {
            sindex = sindex - views.count
        }
        
        if isAdditional
        {
            sindex = stackIndex
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraintEqualToAnchor(anchor: self.leadingAnchor, constant: CGFloat(margin), identifier: "\(sindex)_leadingAnchor").isActive = true
        view.trailingAnchor.constraintEqualToAnchor(anchor: self.trailingAnchor, constant: -CGFloat(margin), identifier: "\(sindex)_trailingAnchor").isActive = true
        view.bottomAnchor.constraintEqualToAnchor(anchor: self.bottomAnchor, constant: -CGFloat(margin), identifier: "\(sindex)_bottomAnchor").isActive = true
        view.topAnchor.constraintEqualToAnchor(anchor: self.topAnchor, constant: CGFloat(top), identifier: "\(sindex)_topAnchor").isActive = true

        addPanGestureTo(view: view)

        stackIndex += 1
        
        if stackIndex == views.count
        {
            stackIndex = 0
        }
    }
    
    
    func addPanGestureTo(view : UIView)
    {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(dragCard(_:)))
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(gesture)
    }
    
    func changeView(oldView : UIView, newView : UIView)
    {
        UIView.animate(withDuration: 0.3) {

            self.constraint(withIdentifier:"\(self.nextIndex)_topAnchor")?.constant = CGFloat(self.space * 2)
            self.constraint(withIdentifier:"\(self.nextIndex)_bottomAnchor")?.constant = 0
            self.constraint(withIdentifier:"\(self.nextIndex)_trailingAnchor")?.constant = 0
            self.constraint(withIdentifier:"\(self.nextIndex)_leadingAnchor")?.constant = 0
        
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.constraint(withIdentifier:"\(self.lastIndex)_topAnchor")?.constant = CGFloat(self.space)
            self.constraint(withIdentifier:"\(self.lastIndex)_bottomAnchor")?.constant = -CGFloat(self.space)
            self.constraint(withIdentifier:"\(self.lastIndex)_trailingAnchor")?.constant = -CGFloat(self.space)
            self.constraint(withIdentifier:"\(self.lastIndex)_leadingAnchor")?.constant = CGFloat(self.space)
            

        }) { (finish) in
            
            oldView.transform = .identity
            oldView.removeFromSuperview()

            self.currentIndex = self.currentIndex + 1
            self.pageChanged?(self.currentIndex)
            self.addNewCard()

//            print("\(self.currentIndex) currentIndex" )
//            print("\(self.nextIndex) nextIndex" )
//            print("\(self.lastIndex) lastIndex" )

            let v = self.views[self.nextIndex]
            self.bringSubviewToFront(v)
            self.bringSubviewToFront(self.currentView)

        }
        
    }
    
    func addNewCard()
    {
        let view = views[lastIndex]
        setupConstraintsOf(view: view, index: (totalCardInStack - 1), isAdditional: true)
    }
    
    @objc func dragCard(_ gestureRecognizer : UIPanGestureRecognizer)
    {
        let v = gestureRecognizer.view!
        if gestureRecognizer.state == .began
        {
            currentViewInitialCenter = v.center
        }
        else if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            let diff = v.bounds.origin.x - v.center.x

            if translation.x < -5
            {
                v.center = CGPoint(x: v.center.x + translation.x, y: v.center.y )
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                if diff < 0
                {
                    let d = 180 / diff
                    if d > -15
                    {    
                        let radians = d / 180.0 * CGFloat.pi
                        let rotation = CGAffineTransform(rotationAngle: radians)
                        v.transform = rotation
                    }
                }
          
            }
           
        }
        else if gestureRecognizer.state == .ended
        {
            let diff = v.bounds.origin.x - v.center.x

            if diff > 0
            {
                changeView(oldView: v, newView: views[nextIndex])
            }
            else
            {
                v.center = currentViewInitialCenter
                v.setNeedsUpdateConstraints()
                v.transform = .identity
            }
        }
    }



}

extension NSLayoutAnchor {
    @objc func constraintEqualToAnchor(anchor: NSLayoutAnchor!, constant:CGFloat, identifier:String) -> NSLayoutConstraint! {
        let constraint = self.constraint(equalTo: anchor, constant:constant)
        constraint.identifier = identifier
        return constraint
    }
}

extension UIView {
    func constraint(withIdentifier:String) -> NSLayoutConstraint? {
        return self.constraints.filter{ $0.identifier == withIdentifier }.first
    }
}
