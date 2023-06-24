//
//  ViewController.swift
//  CustomContainerTextView
//
//  Created by admin on 20/04/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var activeTextView: ActiveTextViewView!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTextView.registerActiveType(
            activeComponentTypes: [
                .more(numberTrimCharacter: 100, content: "... Xem thêm", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cyan]),
                .hashtag(attributes: [NSAttributedString.Key.foregroundColor: UIColor.link]), .url(attributes: [NSAttributedString.Key.foregroundColor: UIColor.green]), .phone(attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])])
    }
    @IBAction func actionReAddText(_ sender: UIButton) {
        activeTextView.setText(text: """
        #hashtag 123 456 #hashtagB dksldksd test
        0357266813 dskdsldksld day la active text #hastagC #hastagD hehehehehehe 123 456 jdskdl mclsl kpdspm mk heheh lelele 0357266813 hehe test test https://facebook.com, test facebook.com 😀 😃 😄 😁 😆 😅 😂 🤣 🥲 🥹 ☺️ 😊 😇 🙂 🙃 😉 😌 😍
        """)
    }
    
    @IBAction func clearCopy(_ sender: UIButton) {
        textField.text = ""
    }
}

