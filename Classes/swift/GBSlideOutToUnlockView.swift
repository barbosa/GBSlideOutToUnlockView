//
//  GBSlideOutToUnlockView.swift
//  GBSlideOutToUnlockView
//
//  Created by Gustavo Barbosa on 6/11/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

import UIKit

@objc protocol GBSlideOutToUnlockViewDelegate {
    @optional func slideOutToUnlockViewDidStartToDrag(slideOutToUnlockView: GBSlideOutToUnlockView)
    @optional func slideOutToUnlockViewDidEndToDrag(slideOutToUnlockView: GBSlideOutToUnlockView)
    @optional func slideOutToUnlockViewDidUnlock(slideOutToUnlockView: GBSlideOutToUnlockView)
    @optional func slideOutToUnlockViewDidNotUnlock(slideOutToUnlockView: GBSlideOutToUnlockView)
    @optional func slideOutToUnlockViewDidDragDistance(slideOutToUnlockView: GBSlideOutToUnlockView, draggedDistance: Float)
}

class GBSlideOutToUnlockView: UIView {
    
    weak var delegate: GBSlideOutToUnlockViewDelegate?
    
    var innerCircleRadius: Float = 25.0
    var outerCircleRadius: Float = 50.0
    
    var innerCircleColor: UIColor?
    var outerCircleColor: UIColor?
    
    var draggableButtonBackgroundColor: UIColor?
    var draggableImageTintColor: UIColor?
    var draggableImage: UIImage?
    
    var _dragButton: UIButton!
    var _unlockOnRelease: Bool = false
    var _distanceMoved: Float = 0.0
    
    init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.innerCircleColor = self.tintColor
        self.outerCircleColor = self.tintColor
        self.draggableButtonBackgroundColor = self.tintColor
        self.draggableImageTintColor = UIColor.whiteColor()
    }
    
    override func drawRect(rect: CGRect) {
        drawCircleWithRadius(innerCircleRadius, color: innerCircleColor)
        drawCircleWithRadius(outerCircleRadius, color: outerCircleColor)
        addRedeemImageAtCenter()
        addPanGestureRecognizerToImage()
    }
    
    func drawCircleWithRadius(radius: Float, color: UIColor!) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        let circleArea = CGRectMake(self.center.x - radius, self.center.y - radius, 2 * radius, 2 * radius)
        CGContextAddEllipseInRect(context, circleArea)
        CGContextStrokePath(context)
    }
    
    func addRedeemImageAtCenter() {
        _dragButton = UIButton(frame: CGRect(x: 0, y: 0, width: 2*self.innerCircleRadius, height: 2*self.innerCircleRadius))
        _dragButton.backgroundColor = self.draggableButtonBackgroundColor
        _dragButton.tintColor = self.draggableImageTintColor
        _dragButton.layer.cornerRadius = self.innerCircleRadius
        _dragButton.layer.masksToBounds = true
        
        var templateImage: UIImage?
        if let rawImage = self.draggableImage {
            templateImage = rawImage.imageWithRenderingMode(.AlwaysTemplate)
        } else {
            templateImage = UIImage(named: "drag_button").imageWithRenderingMode(.AlwaysTemplate)
        }
        
        _dragButton.setImage(templateImage!, forState: .Normal)
        
        self.addSubview(_dragButton)
        _dragButton.center = self.center
    }
    
    func addPanGestureRecognizerToImage() {
        let panGeture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        _dragButton.addGestureRecognizer(panGeture)
    }
    
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .Began {
            _distanceMoved = 0.0
            delegate?.slideOutToUnlockViewDidStartToDrag?(self)
        }
        
        if gestureRecognizer.state == .Changed {
            let translation = gestureRecognizer.translationInView(self)
            _dragButton.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
            
            let a = _dragButton.center.x - self.center.x
            let b = _dragButton.center.y - self.center.y
            _distanceMoved = sqrtf(powf(a, 2.0) + powf(b, 2.0))
            delegate?.slideOutToUnlockViewDidDragDistance?(self, draggedDistance: _distanceMoved)
            
            _unlockOnRelease = _distanceMoved > outerCircleRadius + innerCircleRadius
        }
        
        if gestureRecognizer.state == .Ended {
            delegate?.slideOutToUnlockViewDidEndToDrag?(self)
            
            if _unlockOnRelease {
                delegate?.slideOutToUnlockViewDidUnlock?(self)
            } else {
                delegate?.slideOutToUnlockViewDidNotUnlock?(self)
            }
            
            UIView.animateWithDuration(0.2, animations: {
                self._dragButton.center = self.center
            })
        }
    }
}
