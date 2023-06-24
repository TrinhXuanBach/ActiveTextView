//
//  ActiveTextViewViewable.swift
//  CustomContainerTextView
//
//  Created by admin on 20/04/2023.
//

import Foundation

public protocol ActiveTextViewViewable: AnyObject {
    func onClickSeeMore()
    func onClickToHashTag()
    func onClickToPhone()
    func onClickToMentions()
    func onClickToUrl()
    func onClickToOtherActiveType(activeComponentType: ActiveComponentType)
    func onClickToOtherLocation()
}
