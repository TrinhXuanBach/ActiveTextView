//
//  ActiveTextViewView.swift
//  CustomContainerTextView
//
//  Created by admin on 20/04/2023.
//

import UIKit

public class ActiveTextViewView: UIView {
    private lazy var activeTextView: ActiveTextView = {
        
        var textView: ActiveTextView
        
        if #available(iOS 16, *) {
            textView = ActiveTextView(usingTextLayoutManager: false)
        } else {
            textView = ActiveTextView()
        }
        
        textView.isEditable                                = false
        textView.isSelectable                              = true
        textView.isScrollEnabled                           = false
        textView.textContainer.maximumNumberOfLines        = 0
        textView.textContainerInset                        = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.dataDetectorTypes                         = []
        
        self.addSubview(textView)
        return textView
    }()
    
    private let activeComponentVM = ActiveComponentVM()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGesture                  = UITapGestureRecognizer(target : self, action : #selector(textViewDidTapped(_ :)))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    public weak var delegate: ActiveTextViewViewable?
    
    private func config() {
        configUI()
        configTextView()
    }
    
    private func configUI() {
        NSLayoutConstraint.activate([
            activeTextView.topAnchor.constraint(equalTo: self.topAnchor),
            activeTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            activeTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            activeTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    private func configTextView() {
        activeTextView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    public func registerActiveType(activeComponentTypes: [ActiveComponentType]) {
        activeComponentVM.registerActiveTypeComponents(registerActiveType: activeComponentTypes)
    }
    
    public func registerActiveType(activeComponentType: ActiveComponentType) {
        activeComponentVM.registerActiveTypeComponent(registedActiveType: activeComponentType)
    }
    
    public func unregisterActiveType(activeComponentType: ActiveComponentType) {
        activeComponentVM.unregisterActiveTypeComponent(registedActiveType: activeComponentType)
    }
    
    public func setText(text: String) {
        activeComponentVM.parserComponents(text: text)
        updateAttributedText(attributeText: NSMutableAttributedString(string: text))
    }
    
    public func setAttributeText(attributeText: NSMutableAttributedString) {
        activeComponentVM.parserComponents(text: attributeText.string)
        updateAttributedText(attributeText: attributeText)
    }
    
    private func updateAttributedText(attributeText: NSMutableAttributedString) {
        let activeAttributeText = attributeText
        
        for key in activeComponentVM.components.keys {
            guard let activeComponents = activeComponentVM.components[key] else {
                continue
            }
            
            for activeComponent in activeComponents {
                activeAttributeText.addAttributes(key.getAttributes(), range: activeComponent.range)
                activeAttributeText.addAttribute(NSAttributedString.Key.activeComponentContent, value: activeComponent.content, range: activeComponent.range)
                activeAttributeText.addAttribute(NSAttributedString.Key.activeComponentSchema, value: key.getSchema(), range: activeComponent.range)
            }
        }
        
        if let activeType = activeComponentVM.findActiveComponent(by: Constant.Schema.moreSchema) {
            let clipActiveAttributeText   = ActiveTextViewViewHelper.getCollapseAttributeString(
                attString: activeAttributeText,
                numberTrimCharacter: activeType.getNumberTrimCharacter(),
                patternSeemore: activeType.getContentSeeMore(),
                attributes: activeType.getAttributes())
            activeComponentVM.parserMoreComponent(text: clipActiveAttributeText.string)
            
            guard let activeMoreComponents = activeComponentVM.components[activeType] else {
                return
            }
            
            for activeComponent in activeMoreComponents {
                clipActiveAttributeText.addAttribute(NSAttributedString.Key.activeComponentContent, value: activeComponent.content, range: activeComponent.range)
                clipActiveAttributeText.addAttribute(NSAttributedString.Key.activeComponentSchema, value: activeType.getSchema(), range: activeComponent.range)
            }
            activeTextView.attributedText = clipActiveAttributeText
        } else {
            activeTextView.attributedText = activeAttributeText
        }
    }
}

extension ActiveTextViewView: UIGestureRecognizerDelegate {
    @objc func textViewDidTapped(_ recognizer: UITapGestureRecognizer) {
        guard let activeTextView = recognizer.view as? UITextView else {
            return
        }
        let layoutManager = activeTextView.layoutManager
        var location = recognizer.location(in: activeTextView)
        
        location.x -= activeTextView.textContainerInset.left
        location.y -= activeTextView.textContainerInset.top
        
        let glyphIndex: Int = activeTextView.layoutManager.glyphIndex(for: location, in: activeTextView.textContainer, fractionOfDistanceThroughGlyph: nil)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: activeTextView.textContainer)
        
        if glyphRect.contains(location) {
            let characterIndex: Int = layoutManager.characterIndexForGlyph(at: glyphIndex)
            if let attributeValue = activeTextView.textStorage.attribute(NSAttributedString.Key.activeComponentSchema, at: characterIndex, effectiveRange: nil) as? String,
               let content        = activeTextView.textStorage.attribute(NSAttributedString.Key.activeComponentContent, at: characterIndex, effectiveRange: nil) as? String,
               let activeType = activeComponentVM.findActiveComponent(by: attributeValue) {
                switch activeType {
                case .more:
                    delegate?.onClickSeeMore()
                    print("on click seemore \(content)")
                    return
                case .hashtag:
                    delegate?.onClickToHashTag()
                    print("on click hashtag \(content)")
                case .url:
                    delegate?.onClickToUrl()
                    print("on click url \(content)")
                case.phone:
                    delegate?.onClickToPhone()
                    print("on click phone \(content)")
                case .custom:
                    delegate?.onClickToOtherActiveType(activeComponentType: activeType)
                    print("on click custom")
                default:
                    delegate?.onClickToOtherLocation()
                    print("on click to other location")
                    return
                }
            } else {
                delegate?.onClickToOtherLocation()
                print("on click to other location")
            }
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return activeTextView.selectedRange.length == 0
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard (otherGestureRecognizer as? UITapGestureRecognizer)?.numberOfTapsRequired == 2
        else {
            return false
        }
        return true
    }
}
