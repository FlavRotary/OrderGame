//
//  ScoreCell.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 07/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import UIKit

protocol ScoreCellDelegate {
    func nameDidEndEditing(text: String, cell: ScoreCell)
}

class ScoreCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UITextField!
    
    var delegate: ScoreCellDelegate?
    
    var canBeModified: Bool = false {
        didSet{
            let canIt = self.canBeModified
            if canIt == true {
                self.name.isUserInteractionEnabled = true
                self.name.attributedPlaceholder = NSAttributedString(string: "YourName Here", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 245/255, green: 255/255, blue: 24/255, alpha: 1.0)])
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.delegate = self
    }
    
    func setName(_ name: String){
        self.name.text = name
    }
    func setTime(_ time: String){
        self.time.text = time.formatTime()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.nameDidEndEditing(text: text, cell: self)
            self.canBeModified = false
        }
    }
    
}
