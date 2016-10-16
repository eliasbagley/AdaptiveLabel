//
//  ViewController.swift
//  AdaptiveLabelDemoApp
//
//  Created by Elias Bagley on 10/15/16.
//  Copyright © 2016 Elias Bagley. All rights reserved.
//

import UIKit
import AdaptiveLabel

class ViewController: UIViewController {

    let fixedWidthLabel = AdaptiveLabel(dimensionConstraint: .FixedWidth)
    let fixedHeightLabel = AdaptiveLabel(dimensionConstraint: .FixedHeight)
    let fixedWidthAndHeightLabel = AdaptiveLabel(dimensionConstraint: .FixedWidthAndHeight)

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        self.view.addSubview(fixedWidthLabel)
        self.view.addSubview(fixedHeightLabel)
        self.view.addSubview(fixedWidthAndHeightLabel)

        fixedWidthLabel.text = "Fixed width"
        fixedWidthLabel.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.5)

        fixedHeightLabel.text = "Fixed height"
        fixedHeightLabel.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)

        fixedWidthAndHeightLabel.text = "Width and Height"
        fixedWidthAndHeightLabel.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)

        fixedWidthLabel.translatesAutoresizingMaskIntoConstraints = false
        fixedHeightLabel.translatesAutoresizingMaskIntoConstraints = false
        fixedWidthAndHeightLabel.translatesAutoresizingMaskIntoConstraints = false

        addFixedWidthLabel()
        addFixedHeightLabel()
        addFixedWidthAndHeightLabel()

    }


    // Adds a label pinned to the left and right and top of the screen. The height of the label is allowed to grow to fill the pinned widthed
    func addFixedWidthLabel() {

        let topConstraint = NSLayoutConstraint(item: fixedWidthLabel, attribute: .Top,
                                               relatedBy: .Equal,
                                               toItem: self.view, attribute: .Top,
                                               multiplier: 1.0, constant: 40.0)

        let leftConstraint = NSLayoutConstraint(item: fixedWidthLabel, attribute: .Left,
                                                relatedBy: .Equal,
                                                toItem: self.view, attribute: .Left,
                                                multiplier: 1.0, constant: 20.0)

        let rightConstraint = NSLayoutConstraint(item: fixedWidthLabel, attribute: .Right,
                                                 relatedBy: .Equal,
                                                 toItem: self.view, attribute: .Right,
                                                 multiplier: 1.0, constant: -20.0)

        self.view.addConstraints([topConstraint, leftConstraint, rightConstraint])
    }

    // Adds a label pinned to the top, left, and with a fixed height. The width of the label is allowed to grow to fill fixed height
    func addFixedHeightLabel() {
        let topConstraint = NSLayoutConstraint(item: fixedHeightLabel, attribute: .Top,
                                               relatedBy: .Equal,
                                               toItem: self.view, attribute: .Top,
                                               multiplier: 1.0, constant: 160.0)

        let leftConstraint = NSLayoutConstraint(item: fixedHeightLabel, attribute: .Left,
                                                relatedBy: .Equal,
                                                toItem: self.view, attribute: .Left,
                                                multiplier: 1.0, constant: 20.0)

        // take up 5% of the view's height
        let heightConstraint = NSLayoutConstraint(item: fixedHeightLabel, attribute: .Height,
                                                  relatedBy: .Equal,
                                                  toItem: self.view, attribute: .Height,
                                                  multiplier: 0.05, constant: 0.0)

        self.view.addConstraints([topConstraint, leftConstraint, heightConstraint])

    }

    func addFixedWidthAndHeightLabel() {
        let topConstraint = NSLayoutConstraint(item: fixedWidthAndHeightLabel, attribute: .Top,
                                               relatedBy: .Equal,
                                               toItem: self.view, attribute: .Top,
                                               multiplier: 1.0, constant: 260.0)

        let leftConstraint = NSLayoutConstraint(item: fixedWidthAndHeightLabel, attribute: .Left,
                                                relatedBy: .Equal,
                                                toItem: self.view, attribute: .Left,
                                                multiplier: 1.0, constant: 20.0)

        let rightConstraint = NSLayoutConstraint(item: fixedWidthAndHeightLabel, attribute: .Right,
                                                 relatedBy: .Equal,
                                                 toItem: self.view, attribute: .Right,
                                                 multiplier: 1.0, constant: -20.0)
        // 2% of the screen height
        let heightConstraint = NSLayoutConstraint(item: fixedWidthAndHeightLabel, attribute: .Height,
                                                  relatedBy: .Equal,
                                                  toItem: self.view, attribute: .Height,
                                                  multiplier: 0.02, constant: 0.0)
        
        self.view.addConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
    }
}

