//
//  SpaceBar.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 10/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import UIKit

enum SpaceBarStatus {
    case deactivated
    case activated
}

class SpaceBar: UIView {
    
    var status: SpaceBarStatus? {
        didSet{
            if let currentStatus = status {
                if (currentStatus == .activated){
                    self.backgroundColor = UIColor(red: 245/255, green: 255/255, blue: 24/255, alpha: 1.0)
                    
                } else {
                    self.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        modifyStatus(status: .deactivated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modifyStatus(status: .deactivated)
    }
    
    
    func modifyStatus(status: SpaceBarStatus){
        self.status = status
    }

}
