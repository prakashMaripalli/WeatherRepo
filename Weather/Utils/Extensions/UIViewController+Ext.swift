//
//  UIViewController+Ext.swift
//  Weather
//
//  Created by Prakash maripalli on 5/18/23.
//

import UIKit

extension UIViewController {
    func showAlert(messae: String) {
        let alert = UIAlertController.init(title: "Info!", message: messae, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
