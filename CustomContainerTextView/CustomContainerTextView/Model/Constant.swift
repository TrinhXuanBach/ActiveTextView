//
//  Constant.swift
//  CustomContainerTextView
//
//  Created by admin on 20/04/2023.
//

import Foundation

public struct Constant {
    public struct Schema {
        public static let hashTagSchema : String = "HASHTAG"
        public static let urlSchema     : String = "URL"
        public static let phoneSchema   : String = "PHONE"
        public static let mentionsSchema: String = "MENTION"
        public static let moreSchema    : String = "MORE"
    }
    
    public struct Regex {
        public static let hashTagRegex : String = "(?:^|\\s|$)#[\\p{L}0-9_]*"
        public static let urlRegex     : String = "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
        public static let phoneRegex   : String = [
            // Đầu số (null|0|+84|84) + (69) + 6 số
            "\\b(0{0,1}|\\+84|84)(69)[0-9]{6}\\b",
            // Đầu số (null|0|+84|84) + (3|5|6|7|8|9) + 8 số
            "\\b(0{0,1}|\\+84|84)(3|5|6|7|8|9)[0-9]{8}\\b",
            // Đầu số (null|0|+84|84) + (2) + 9 số
            "\\b(0{0,1}|\\+84|84)(2)[0-9]{9}\\b",
        ].joined(separator: "|")
    }
}
