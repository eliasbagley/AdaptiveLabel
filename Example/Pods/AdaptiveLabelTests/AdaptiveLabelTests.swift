//
//  AdaptiveLabelTests.swift
//  AdaptiveLabelTests
//
//  Created by Elias Bagley on 10/22/16.
//
//

import XCTest

class TestWindow: UIWindow {
}

private let ASPECT_RATIO: CGFloat =  1.5
private let WIDTH_SMALL: CGFloat = 500
private let WIDTH_MED: CGFloat = 1000

func approxEqual(lhs lhs: CGFloat, rhs: CGFloat, epsilon: CGFloat = 0.01) -> Bool {
    let ratio = lhs/rhs
    return (ratio >= (1 - epsilon)) && ratio <= (1 + epsilon)
}

class AdaptiveLabelTests: XCTestCase {

    var testWindowSmall = TestWindow(frame: CGRectMake(0, 0, WIDTH_SMALL, WIDTH_SMALL * ASPECT_RATIO))
    var testWindowMed = TestWindow(frame: CGRectMake(0, 0, WIDTH_MED, WIDTH_MED * ASPECT_RATIO))

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_fixedWidthLabel_relativeHeightsAreProportional() {
        let fixedWidthLabel1 = AdaptiveLabel(dimensionConstraint: .FixedWidth)
        let fixedWidthLabel2 = AdaptiveLabel(dimensionConstraint: .FixedWidth)
        let widthPercentage: CGFloat = 1

        fixedWidthLabel1.text = "Test text"
        fixedWidthLabel2.text = "Test text"

        testWindowSmall.addSubview(fixedWidthLabel1)
        testWindowMed.addSubview(fixedWidthLabel2)

        fixedWidthLabel1.translatesAutoresizingMaskIntoConstraints = false
        fixedWidthLabel2.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint1 = fixedWidthLabel1.widthAnchor.constraintEqualToAnchor(testWindowSmall.widthAnchor, multiplier: widthPercentage)
        testWindowSmall.addConstraint(widthConstraint1)

        let widthConstraint2 = fixedWidthLabel2.widthAnchor.constraintEqualToAnchor(testWindowMed.widthAnchor, multiplier: widthPercentage)
        testWindowMed.addConstraint(widthConstraint2)

        testWindowSmall.layoutIfNeeded()
        testWindowMed.layoutIfNeeded()


        // Assert that labels are the correct width
        XCTAssertTrue(fixedWidthLabel1.frame.width == widthPercentage * testWindowSmall.frame.width , "Label width should be correct width")
        XCTAssertTrue(fixedWidthLabel2.frame.width == widthPercentage * testWindowMed.frame.width , "Label width should be correct width")

        // assert that the relative height is the same
        let percentHeight1 = fixedWidthLabel1.bounds.height / testWindowSmall.bounds.height
        let percentHeight2 = fixedWidthLabel2.bounds.height / testWindowMed.bounds.height
        XCTAssertTrue(approxEqual(lhs: percentHeight1, rhs: percentHeight2), "the percentage of the height the label occupies is the same across screen sizes")
    }

    func test_fixedHeightLabel_relativeWidthsAreProportional() {
        let fixedHeightLabel1 = AdaptiveLabel(dimensionConstraint: .FixedHeight)
        let fixedHeightLabel2 = AdaptiveLabel(dimensionConstraint: .FixedHeight)
        let heightPercentage: CGFloat = 0.3

        fixedHeightLabel1.text = "Test text"
        fixedHeightLabel2.text = "Test text"

        testWindowSmall.addSubview(fixedHeightLabel1)
        testWindowMed.addSubview(fixedHeightLabel2)

        fixedHeightLabel1.translatesAutoresizingMaskIntoConstraints = false
        fixedHeightLabel2.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint1 = fixedHeightLabel1.heightAnchor.constraintEqualToAnchor(testWindowSmall.heightAnchor, multiplier: heightPercentage)
        testWindowSmall.addConstraint(heightConstraint1)

        let heightConstraint2 = fixedHeightLabel2.heightAnchor.constraintEqualToAnchor(testWindowMed.heightAnchor, multiplier: heightPercentage)
        testWindowMed.addConstraint(heightConstraint2)

        testWindowSmall.layoutIfNeeded()
        testWindowMed.layoutIfNeeded()


        // Assert that labels are the correct height
        XCTAssertTrue(fixedHeightLabel1.frame.height == heightPercentage * testWindowSmall.frame.height , "Label height should be correct height")
        XCTAssertTrue(fixedHeightLabel2.frame.height == heightPercentage * testWindowMed.frame.height , "Label height should be correct height")

        // assert that the relative height is the same
        let percentHeight1 = fixedHeightLabel1.bounds.height / testWindowSmall.bounds.height
        let percentHeight2 = fixedHeightLabel2.bounds.height / testWindowMed.bounds.height
        XCTAssertTrue(approxEqual(lhs: percentHeight1, rhs: percentHeight2), "the percentage of the height the label occupies is the same across screen sizes")
    }

    // test fixed width and height, with same width and assert that just the text spacing changes

}

    // test changing text re lays out

    // test layout out on all layout passes

    // test fixed width and height

    // test non-convergance

    // test mins and maxes
