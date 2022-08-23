//
//  ContentsOfFileVC.swift
//  Galaktion Nizharadze, Assignment #25
//
//  Created by Gaga Nizharadze on 23.08.22.
//

import Foundation
import UIKit

class ContentsOfFileVC: UIViewController {
    var text: String! {
        didSet {
            textView.text = text
        }
    }
    
    var currentFileURL: URL!
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(textView)
        textView.frame = CGRect(x: 20, y: 50, width: view.frame.width - 40, height: view.frame.height - 50)
        textView.text = text
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        do {
            try textView.text.write(to: currentFileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print(error)
        }
    }
}
