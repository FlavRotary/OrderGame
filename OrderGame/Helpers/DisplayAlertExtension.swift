//
//  DisplayAlertExtension.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 09/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func createAndDisplayAlert(title: String, Message: String, Button: String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let button = UIAlertAction(title: Button, style: .default, handler: { (action) in
        })
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
}
