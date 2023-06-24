//
//  StringExtensionActiveTextViewView.swift
//  CustomContainerTextView
//
//  Created by admin on 23/04/2023.
//

import Foundation

import Foundation

extension String.UTF16View {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.UTF16View.Index>? {
        guard
            let from16 = self.index(self.startIndex, offsetBy: nsRange.location, limitedBy: self.endIndex),
            let to16 = self.index(self.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: self.endIndex)
        else { return nil }
        return from16 ..< to16
    }
}
