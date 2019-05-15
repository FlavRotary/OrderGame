//
//  Game.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 07/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import Foundation

enum GameErrors : String,Error{
    case elementNotFound = "Specified Item Could not be found"
    case moveFail = "Moving of the specified item Failed"
}

class Game {
    
    var numbers: [Int] = []
    var isOver : Bool
    
    init(){
        
        let dimension = 9
        while numbers.count != dimension {
            let randomNumber = Int.random(in: 1...99)
            if numbers.contains(randomNumber) {
                continue
            } else {
                numbers.append(randomNumber)
            }
        }
        self.numbers.shuffle()
        self.isOver = false
        
    }

    func moveItem(_ element: Int, _ atPos: Int) throws {
        
        guard let index = numbers.firstIndex(of: element) else {
            throw GameErrors.elementNotFound
        }
        numbers.remove(at: index)
        numbers.insert(element, at: atPos)
        
        guard numbers.firstIndex(of: element) == numbers.lastIndex(of: element) else {
            throw GameErrors.moveFail
        }
        
    }
    
    func checkItems() {
        var isValid = true
        for index in 0...numbers.count-2 {
            if numbers[index] > numbers[index+1]{
                isValid = false
                break
            }
        }
        self.isOver = isValid
    }   
    
    
}
