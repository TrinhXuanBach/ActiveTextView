# CustomContainerTextView

An iOS UIKit component (`ActiveTextViewView`) that renders text with tappable "active" segments — hashtags, URLs, phone numbers, mentions, a "see more" truncation link, and custom regex-defined types — each with its own style and tap callback.

## Function

- Detects and styles substrings matching registered patterns (hashtag, URL, phone, mention, or any custom regex/schema) inside a block of text.
- Lets each active type carry its own `NSAttributedString` attributes (color, font, etc.) and its own schema identifier.
- Supports a "more" (`... Xem thêm` / "see more") type that trims text to a character limit and exposes a tap to expand it.
- Reports taps through a delegate, telling the caller which active type (and its matched content) was tapped, or that the tap landed on plain text.

## Architecture

```
ActiveTextViewView (UIView)
 ├─ ActiveTextView (UITextView subclass)       — display surface; clears selection on edit-menu dismiss
 ├─ ActiveComponentVM                          — holds registered types + parsed components per type
 │   └─ ActiveComponentParser                  — regex-matches text into ActiveComponent ranges
 ├─ ActiveComponentType (enum)                 — .hashtag / .url / .phone / .mention / .more / .custom
 ├─ ActiveComponent                            — a single match: schema, content, NSRange
 └─ ActiveTextViewViewHelper                   — builds the collapsed/"see more" attributed string
```

- **Model**: `ActiveComponentType`, `ActiveComponentParser`, `ActiveComponentVM`, `ActiveComponent`, `Constant` (default regex patterns and schema keys).
- **View**: `ActiveTextViewView` (public container) and `ActiveTextView` (internal `UITextView`).
- **Protocol**: `ActiveTextViewViewable` (tap delegate), `ActiveTextViewViewConfigable`.
- **Extension**: `NSAttributeStringExtension`, `StringExtensionActiveTextViewView` — string/attributed-string helpers used by the parser and collapse logic.
- **Helper**: `ActiveTextViewViewHelper` — builds the trimmed "see more" attributed text.

Flow: `setText`/`setAttributeText` → `ActiveComponentVM.parserComponents` matches each registered type against the text → matches are applied as attributes (color + schema + content) on the attributed string → if a `.more` type is registered, the text is collapsed and a trailing "see more" link is appended → a single `UITapGestureRecognizer` on the text view resolves the tapped character's schema/content and calls the matching delegate method.

## How to use

1. Add `ActiveTextViewView` to a view (via Interface Builder or code) and set its `delegate`.
2. Register the active types you want detected, each with its attributes:

```swift
activeTextView.delegate = self
activeTextView.registerActiveType(activeComponentTypes: [
    .hashtag(attributes: [.foregroundColor: UIColor.link]),
    .url(attributes: [.foregroundColor: UIColor.green]),
    .phone(attributes: [.foregroundColor: UIColor.red]),
    .more(numberTrimCharacter: 100, content: "... See more",
          attributes: [.foregroundColor: UIColor.cyan])
])
```

3. Set the text to display:

```swift
activeTextView.setText(text: "#hashtag check https://example.com or call 0357266813")
// or, to start from an existing attributed string:
activeTextView.setAttributeText(attributeText: someAttributedString)
```

4. Handle taps by conforming to `ActiveTextViewViewable`:

```swift
extension ViewController: ActiveTextViewViewable {
    func onClickToHashTag() { /* ... */ }
    func onClickToUrl() { /* ... */ }
    func onClickToPhone() { /* ... */ }
    func onClickToMentions() { /* ... */ }
    func onClickSeeMore() { /* expand text, e.g. re-call setText with full content */ }
    func onClickToOtherActiveType(activeComponentType: ActiveComponentType) { /* custom types */ }
    func onClickToOtherLocation() { /* tap landed on non-active text */ }
}
```

5. To add a custom pattern beyond the built-ins:

```swift
activeTextView.registerActiveType(activeComponentType: .custom(
    regex: "your-regex-here",
    schema: "your-schema-id",
    attributes: [.foregroundColor: UIColor.orange]))
```

Use `unregisterActiveType(activeComponentType:)` to remove a previously registered type.

## Project

Xcode project: `CustomContainerTextView.xcodeproj`. Open it in Xcode and run the `CustomContainerTextView` target on an iOS simulator/device; `ViewController.swift` contains a sample usage with hashtag/URL/phone detection and a "see more" demo.
