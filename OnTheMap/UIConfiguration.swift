//
//  UIConfiguration.swift
//  On The Map
//
//  Created by Shroog Salem on 03/12/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import Foundation
import UIKit

fileprivate var activityView: UIView?

extension UIViewController {
    
    //MARK: - Activity Indicator Adjustments
    func showSpinner() {
        
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center=activityView!.center
        ai.startAnimating()
        activityView?.addSubview(ai)
        self.view.addSubview(activityView!)
        
    }
    
    func removeSpinner() {
        DispatchQueue.main.async{
            activityView?.removeFromSuperview()
            activityView = nil
        }
       
    }
    
    //MARK: - Alert
    func alert (title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Overwrite Alert
    func overwriteAlert(){
        let alert = UIAlertController(title: "You Have Already Posted a Student Location. \n Would you like to overwrite your current location?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: { (action) in self.performSegue(withIdentifier: "addNewPin", sender: self)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Notification
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Keyboard adjusments
    @objc func keyboardWillShow(_ notification:Notification) {
        guard UIResponder.self is UITextField else { return }
            view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    
}
