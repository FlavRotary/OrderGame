//
//  StringTimeFormat.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 07/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import Foundation

extension String {
    func formatTime() -> String{
        let intValue = Int(self)!
        let sec = intValue % 60
        let min = intValue / 60
        let seconds = sec < 10 ? "0\(sec)" : "\(sec)"
        let minutes = min < 10 ? "0\(min)" : "\(min)"
        return minutes + ":" + seconds
    }
}
