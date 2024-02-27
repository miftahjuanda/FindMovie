//
//  ViewController+Ext.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 25/02/24.
//

import UIKit

internal extension UIViewController {
    func presentPopup(title: String, message: String, dismissHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            dismissHandler?()
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
