//
//  Score.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 06/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import Foundation

class Score: Codable {
    var id: String!
    var name: String!
    var value: String!
    
    init(_ id: String, _ name: String, _ value: String) {
        self.id = id
        self.name = name
        self.value = value
    }
    
    init(_ value: String){
        self.id = "0"
        self.name = ""
        self.value = value
    }
}
