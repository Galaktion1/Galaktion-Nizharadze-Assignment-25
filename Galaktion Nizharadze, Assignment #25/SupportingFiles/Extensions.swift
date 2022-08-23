//
//  Extensions.swift
//  Galaktion Nizharadze, Assignment #25
//
//  Created by Gaga Nizharadze on 23.08.22.
//

import Foundation
import UIKit


extension UIViewController {
    func presentAlertForFileNaming( dirCreationClosure: @escaping (String) -> ()) {
        let alertController = UIAlertController(title: "File Naming",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        
        let continueAction = UIAlertAction(title: "Continue",
                                           style: .default) { [weak alertController] _ in
            
            guard let textFields = alertController?.textFields else { return }
            
            guard let directoryTitle = textFields[0].text else { return }
            
            
            dirCreationClosure(directoryTitle)
        }
        
        alertController.addAction(continueAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alertController, animated: true)
    }
}
