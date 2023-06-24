//
//  ActiveComponentParser.swift
//  CustomContainerTextView
//
//  Created by admin on 20/04/2023.
//

import Foundation

class ActiveComponentParser {
    func createElements(type: ActiveComponentType, from text: String) -> [ActiveComponent] {
        var findedElementsRange = [ActiveComponent]()
        let regexInRange        = NSRange(location: 0, length: text.utf16.count)
        
        if let regexPattern = type.getRegex(),
           let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive) {
            let matches = regex.matches(in: text, range: regexInRange)
            
            let utf16view = text.utf16
            
            findedElementsRange = matches.compactMap({ result -> ActiveComponent? in
                guard let rangeInUT18View = utf16view.rangeFromNSRange(nsRange: result.range) else {
                    return nil
                }
                
                return ActiveComponent(content: String(Substring(utf16view[rangeInUT18View])), range: result.range)
            })
        }
        
        return findedElementsRange
    }
    
    func createMoreElement(type: ActiveComponentType, from text: String) -> [ActiveComponent] {
        var findedElementsRange = [ActiveComponent]()
        let regexInRange = NSRange(location: 0, length: text.utf16.count)
        let regexPattern = "\(type.getContentSeeMore())$"
        if let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive) {
            let matches   = regex.matches(in: text, range: regexInRange)
            let utf16view = text.utf16
            findedElementsRange = matches.compactMap({ result -> ActiveComponent? in
                guard let rangeInUT18View = utf16view.rangeFromNSRange(nsRange: result.range) else {
                    return nil
                }
                
                return ActiveComponent(content: String(Substring(utf16view[rangeInUT18View])), range: result.range)
            })
        }
        return findedElementsRange
    }
}
