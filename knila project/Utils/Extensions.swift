//
//  Extensions.swift
//  knila project
//
//  Created by Fuzionest on 09/07/21.
//

import UIKit

class Extensions: NSObject {
   class func showAlert(_ string:String,_ view:UIViewController) {
        let otherAlert = UIAlertController(title: "KNILA", message: string, preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        // relate actions to controllers
        
        otherAlert.addAction(dismiss)
        view.present(otherAlert, animated: true, completion: nil)
    }
}


