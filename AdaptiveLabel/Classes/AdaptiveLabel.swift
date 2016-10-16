//
//  AdaptiveLabel.swift
//  AdaptiveLabel
//
//  Created by Elias Bagley on 10/15/16.
//  Copyright © 2016 Elias Bagley. All rights reserved.
//

import UIKit

/*
 This label subclass can be used with a label of a fixed width, fixed height, or both.
 When the label has a fixed width or height (usually by a constraint), the label will calculate the best size by binary searching the font size until the height of the label matches the fixed dimension.

 When the label has a fix width AND fixed height, the label will calculate the best size by fitst binary searching on the font size until it reaches the maximum height possible. At this point, it switches to binary searching the character spacing  until it reaches the desired width, so it fits nearly perfectly in the container.

 Currently only works for single line labels.
 */

extension UILabel {
    func setText(text: String?, withSpacing spacing: CGFloat?) {
        guard let text = text else {
            self.text = nil
            self.attributedText = nil
            return
        }

        let attributedString = NSMutableAttributedString(string: text)
        if let spacing = spacing {
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        }
        self.attributedText = attributedString

    }
}

public enum DimensionConstraint {
    case FixedWidth
    case FixedHeight
    case FixedWidthAndHeight
}

private enum Comparison {
    case GreaterThan
    case LessThan
    case Equal
}



public class AdaptiveLabel: UILabel {

    // config flags
    var hasBeenFit: Bool = false
    var shouldReconstrainOnEveryLayoutPass = false

    // Min and Max spacing to use during binary search
    var MIN_SPACING: CGFloat = 0
    var MAX_SPACING: CGFloat = 30

    // Min and max font sizes to use during binary serach
    var MIN_FONT: CGFloat = 5
    var MAX_FONT: CGFloat = 300

    // A percetnage determining how close "close enough" is during binary search
    var EPSILON: CGFloat = 0.02

    private var fontSearcher: FloatBinarySearcher!
    private var spacingSearcher: FloatBinarySearcher!


    let dimensionConstraint: DimensionConstraint

    var myText: String? {
        didSet {
            if myText != nil {
                fitToConstraints()
            }
        }
    }

    override public var text: String? {
        didSet {
            self.myText = text
        }
    }

    var maxHeight: CGFloat {
        return self.bounds.height
    }

    var maxWidth: CGFloat {
        return self.bounds.width
    }

    // Returns the best-fit font size
    var fontSize: CGFloat {
        return fontSearcher.current
    }

    // Returns the best-fit spacing, if the dimensionConstraint is .FixedWidthAndHeight
    var spacing: CGFloat {
        return spacingSearcher.current
    }

    public init(dimensionConstraint: DimensionConstraint) {
        self.dimensionConstraint = dimensionConstraint
        super.init(frame: CGRectZero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override public func layoutSubviews() {
        super.layoutSubviews()

        if hasBeenFit == false || shouldReconstrainOnEveryLayoutPass {
            fitToConstraints()
        }
    }

    func fitToConstraints() {
        if self.bounds == CGRectZero || self.myText == nil {
            // Nothing to fit.
            return
        }

        refreshSearchers()

        switch dimensionConstraint {
        case .FixedWidthAndHeight:
            binarySearchForFontAndSpacing()
        default:
            binarySearchForFont()
        }

        self.hasBeenFit = true
    }

    //MARK: Private methods

    private func refreshSearchers() {
        self.fontSearcher = FloatBinarySearcher(low: MIN_FONT, high: MAX_FONT) // sane defaults for fonts
        self.spacingSearcher = FloatBinarySearcher(low: MIN_SPACING, high: MAX_SPACING) // sane defaults for spacing
    }

    private func binarySearchForFont() {
        var comparison = areWeDoneYet(fontSearcher.current)
        while comparison != .Equal {
            fontSearcher.update(comparison)
            comparison = areWeDoneYet(fontSearcher.current)
        }

        updateText(fontSearcher.current)
    }

    private func binarySearchForFontAndSpacing() {
        // Binary search on font to get to the maximum font size
        var reachedMaxHeight = hasReachedMaxHeight(fontSearcher.current)
        while reachedMaxHeight != .Equal {
            fontSearcher.update(reachedMaxHeight)
            reachedMaxHeight = hasReachedMaxHeight(fontSearcher.current)
        }

        // Binary search on spacing to fill out width
        var comparison = areWeDoneYet(fontSearcher.current, spacing: spacingSearcher.current)
        while comparison != .Equal {
            spacingSearcher.update(comparison)
            comparison = areWeDoneYet(fontSearcher.current, spacing: spacingSearcher.current)
        }

        updateText(fontSearcher.current, spacing: spacingSearcher.current)
    }



    private func hasReachedMaxHeight(fontSize: CGFloat) -> Comparison {
        let fontSize = getSizeWithFont(fontSize)

        if isApproxEqual(fontSize.height, rhs: maxHeight, epsilon: EPSILON) {
            return .Equal
        }

        if fontSize.height > maxHeight {
            return .GreaterThan
        }

        return .LessThan
    }

    private func hasReachedMaxWidth(fontSize: CGFloat, spacing: CGFloat? = nil) -> Comparison {
        let fontSize = getSizeWithFont(fontSize, spacing: spacing)

        if isApproxEqual(fontSize.width, rhs: maxWidth, epsilon: EPSILON) {
            return .Equal
        }

        if fontSize.width > maxWidth {
            return .GreaterThan
        }

        return .LessThan
    }

    private func getFont(size: CGFloat) -> UIFont {
        return self.font.fontWithSize(size)
    }

    private func getSizeWithFont(fontSize: CGFloat, spacing: CGFloat? = nil) -> CGSize {
        guard let text = self.myText else {
            return CGSizeZero
        }

        let font = getFont(fontSize)

        if let spacing = spacing {
            return text.sizeWithAttributes(
                [
                    NSFontAttributeName: font,
                    NSKernAttributeName: spacing
                ])
        }

        return text.sizeWithAttributes(
            [
                NSFontAttributeName: font
            ])
    }

    private func areWeDoneYet(fontSize: CGFloat, spacing: CGFloat? = nil) -> Comparison {
        switch dimensionConstraint {
        case .FixedWidth:
            return hasReachedMaxWidth(fontSize)
        case .FixedHeight:
            return hasReachedMaxHeight(fontSize)
        case .FixedWidthAndHeight:
            let reachedMaxWidth = hasReachedMaxWidth(fontSize, spacing: spacing)
            let reachedMaxHeight = hasReachedMaxHeight(fontSize)
            if reachedMaxWidth == .Equal && reachedMaxHeight == .Equal {
                return .Equal
            }

            if reachedMaxWidth == .GreaterThan || reachedMaxHeight == .GreaterThan {
                return .GreaterThan
            }

            return .LessThan
        }
    }

    private func updateText(fontSize: CGFloat, spacing: CGFloat? = nil) {
        self.font = getFont(fontSize)
        self.setText(self.myText, withSpacing: spacing)
    }
}

//MARK: Helpers

// checks whether lhs and rhs are within [1-epsilon, epsilon] percentage of eachother
private func isApproxEqual(lhs: CGFloat, rhs: CGFloat, epsilon: CGFloat) -> Bool{
    let ratio = lhs/rhs
    return (ratio >= (1 - epsilon)) && ratio <= 1
}

// Simple binary searcher on a float range by bisecting and updating
private class FloatBinarySearcher {
    var low: CGFloat
    var high: CGFloat
    var current: CGFloat

    init(low: CGFloat, high: CGFloat) {
        if low > high {
            fatalError("Cannot initialize a binary searcher with low > high!")
        }
        self.low = low
        self.high = high
        self.current = (low + high) / 2
    }

    func update(comparison: Comparison) {
        if comparison == .GreaterThan {
            high = current
        }

        if comparison == .LessThan {
            low = current
        }

        self.current = (low + high) / 2

    }
}
