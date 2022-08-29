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
    
    var currentDate = Date()
    var currentFileURL: URL!
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        confTextView()
        confDatePicker()
       
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        do {
            try textView.text.write(to: currentFileURL, atomically: false, encoding: .utf8)
            checkIfNotificationShouldSend()
        }
        catch {
            print(error)
        }
    }
    
    
    private func confTextView() {
        view.addSubview(textView)
        
        textView.frame = CGRect(x: Constants.textViewXConstraint,
                                y: Constants.textViewYConstraint,
                                width: view.frame.width - 40,
                                height: view.frame.height - 80)
    }
    
    
    private func checkIfNotificationShouldSend() {
        if datePicker.date > currentDate.addingTimeInterval(Constants.minimumDuration) {
            
            let differenceBetweenDates = Int(Date.differenceBetween(lhs: datePicker.date, rhs: currentDate))
            
            LocalLocationManager.register(notification: LocalNotification(id: UUID().uuidString , title: currentFileURL.lastPathComponent, message: textView.text), duration: differenceBetweenDates, repeats: false, userInfo: ["" : 0])
        }
    }
    
    
    private func confDatePicker() {
        view.addSubview(datePicker)
        datePicker.frame = CGRect(x: view.frame.width - 220, y: 30, width: Constants.datePickerWidth, height: Constants.datePickerHeight)
        
        currentDate = datePicker.date
    }
    
    
    private struct Constants {
        static let minimumDuration: TimeInterval = 30
        static let datePickerWidth: CGFloat = 200
        static let datePickerHeight: CGFloat = 40
        static let textViewXConstraint: CGFloat = 20
        static let textViewYConstraint: CGFloat = 80
    }
}



extension Date {

    static func  differenceBetween(lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
