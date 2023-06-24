//
//  ActiveComponentType.swift
//  CustomContainerTextView
//
//  Created by admin on 20/04/2023.
//

import Foundation

public enum ActiveComponentType: Hashable {
    case hashtag(regex      : String? = Constant.Regex.hashTagRegex,
                 attributes : [NSAttributedString.Key : Any])
    case url(regex      : String? = Constant.Regex.urlRegex,
             attributes : [NSAttributedString.Key : Any])
    case phone(regex      : String? = Constant.Regex.phoneRegex,
               attributes : [NSAttributedString.Key : Any])
    case mention(regex      : String?,
                 attributes : [NSAttributedString.Key : Any])
    case more(numberTrimCharacter : Int,
              content             : String,
              attributes          : [NSAttributedString.Key : Any])
    case custom(regex      : String?,
                schema     : String,
                attributes : [NSAttributedString.Key : Any])
    
    internal func getAttributes() -> [NSAttributedString.Key: Any] {
        switch self {
        case .hashtag(_, let attributes),
                .url(_, let attributes),
                .phone(_, let attributes),
                .mention(_, let attributes),
                .custom(_, _, let attributes),
                .more(_, _, let attributes):
            return attributes
        }
    }
    
    internal func getSchema() -> String {
        switch self {
        case .custom(_, let schema, _):
            return schema
        case .hashtag:
            return Constant.Schema.hashTagSchema
        case .url:
            return Constant.Schema.urlSchema
        case .phone:
            return Constant.Schema.phoneSchema
        case .mention:
            return Constant.Schema.mentionsSchema
        case .more:
            return Constant.Schema.moreSchema
        }
    }
    
    internal func getRegex() -> String? {
        switch self {
        case .hashtag(let regex, _),
                .url(let regex, _),
                .phone(let regex, _),
                .custom(let regex, _, _):
            return regex
        default:
            return ""
        }
    }
    
    internal func getNumberTrimCharacter() -> Int {
        switch self {
        case .more(let numberTrimCharacter, _, _):
            return numberTrimCharacter
        default:
            return 0
        }
    }
    
    internal func getContentSeeMore() -> String {
        switch self {
        case .more(_, let content, _):
            return content
        default:
            return ""
        }
    }
    
    public static func == (lhs: ActiveComponentType, rhs: ActiveComponentType) -> Bool {
        lhs.getSchema() == rhs.getSchema()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(getSchema())
    }
}
