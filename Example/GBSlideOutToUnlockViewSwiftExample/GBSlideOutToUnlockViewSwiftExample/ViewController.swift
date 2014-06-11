//
//  ViewController.swift
//  GBSlideOutToUnlockViewSwiftExample
//
//  Created by Gustavo Barbosa on 6/11/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GBSlideOutToUnlockViewDelegate {
    
    let kHorizontalMargin = 20.0

    @IBOutlet var containerView: UIView
    @IBOutlet var currentStateLabel: UILabel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var slideToUnlockView = GBSlideOutToUnlockView(frame: containerView.bounds)
        slideToUnlockView.delegate = self
        containerView.addSubview(slideToUnlockView)
        slideToUnlockView.outerCircleRadius = CGRectGetWidth(containerView.bounds) / CGFloat(2.0) - CGFloat(2.0)*CGFloat(kHorizontalMargin)
    }
    
    func slideOutToUnlockViewDidStartToDrag(slideOutToUnlockView: GBSlideOutToUnlockView) {
        currentStateLabel.text = "Started"
        currentStateLabel.backgroundColor = UIColor.blackColor()
    }
    
    func slideOutToUnlockViewDidUnlock(slideOutToUnlockView: GBSlideOutToUnlockView) {
        currentStateLabel.text = "Unlocked"
        currentStateLabel.backgroundColor = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
    }
    
    func slideOutToUnlockViewDidNotUnlock(slideOutToUnlockView: GBSlideOutToUnlockView) {
        currentStateLabel.text = "Did not unlock"
        currentStateLabel.backgroundColor = UIColor(red: 0.7, green: 0, blue: 0, alpha: 1)
    }
}