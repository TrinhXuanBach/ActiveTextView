//
//  ActiveTextViewViewHelper.swift
//  CustomContainerTextView
//
//  Created by admin on 24/04/2023.
//

import Foundation

import Foundation

struct ActiveTextViewViewHelper {
    static func getCollapseAttributeString(attString                : NSMutableAttributedString,
                                           numberTrimCharacter      : Int,
                                           patternSeemore           : String,
                                           attributes               : [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let range = attString.mutableString.range(of: String(attString.string.prefix(numberTrimCharacter)),
                                                  options: .literal)
        let newAttString = attString.attributedSubstring(from: range)  as! NSMutableAttributedString
        newAttString.append(NSAttributedString(string: patternSeemore, attributes: attributes))
        return newAttString
    }
}
