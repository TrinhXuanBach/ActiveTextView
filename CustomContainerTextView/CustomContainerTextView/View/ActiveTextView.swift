//
//  ActiveTextView.swift
//  CustomContainerTextView
//
//  Created by admin on 21/04/2023.
//

import Foundation
import UIKit

class ActiveTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        guard #unavailable(iOS 16) else { return }
        observeDismissEditMenu()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        guard #unavailable(iOS 16) else { return }
        observeDismissEditMenu()
    }
    
    @available(iOS 16.0, *)
    override func willDismissEditMenu(animator: UIEditMenuInteractionAnimating) {
        self.selectedRange = NSRange(location: 0, length: 0)
        super.willDismissEditMenu(animator: animator)
    }
    
    private func observeDismissEditMenu() {
        NotificationCenter.default.addObserver(self, selector: #selector(hideSelectedRange), name: UIMenuController.willHideMenuNotification, object: nil)
    }
    
    private func removeObserverDismissEditMenu() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func hideSelectedRange() {
        self.selectedRange = NSRange(location: 0, length: 0)
    }
    
    deinit {
        guard #unavailable(iOS 16) else { return }
        removeObserverDismissEditMenu()
    }
}
