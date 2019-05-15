//
//  GameSpace.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 08/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import UIKit

enum GameSpaceErrors : String, Error {
    case numbersMismatch = "Numbers mismatch between Square counts and RandomNumbers Count"
    case spacesNumberMismatch = "Numbers mismatch between number of spaces and RandomNumbers Count"
    case getCoordinatesFailed = "Failed to retrieve a specific coordinate"
    case translationFailed = "Failed to translate Squares"
    case shadowSquareFail = "Error in creating/adding the Shadow Square"
}

class GameSpace: UIView {
    
    var GSOrigin: CGPoint!
    var GSCenter: CGPoint!
    var GSWidth: CGFloat!
    var GSHeight: CGFloat!
    
    var squares: [Square] = []
    var spaceBars: [SpaceBar] = []
    
    func createSpace(for numbers: [Int]) -> Error?{
        
        guard getCoordinates() == nil else {
            return GameSpaceErrors.getCoordinatesFailed
        }
        generateSquares(for: numbers)
        guard numbers.count == squares.count else {
             return GameSpaceErrors.numbersMismatch
        }
        generateSpaceBars(for: numbers)
        guard numbers.count + 1 == spaceBars.count else {
            return GameSpaceErrors.spacesNumberMismatch
        }
        return nil
        
    }
    
    func getCoordinates() -> Error?{
        
        GSWidth = bounds.width
        guard GSWidth != nil else {
            return GameSpaceErrors.getCoordinatesFailed
        }
        
        GSHeight = bounds.height
        guard GSHeight != nil else {
            return GameSpaceErrors.getCoordinatesFailed
        }
        
        GSOrigin = frame.origin
        guard GSOrigin != nil else {
            return GameSpaceErrors.getCoordinatesFailed
        }
        
        GSCenter = CGPoint(x: bounds.origin.x + GSWidth/2, y: bounds.origin.y + GSHeight/2)
        guard GSCenter != nil else {
            return GameSpaceErrors.getCoordinatesFailed
        }
        
        return nil
        
    }
    
    func translateSquares () -> Error?{
        
        guard getCoordinates() == nil else {
            return GameSpaceErrors.getCoordinatesFailed
        }
        
        let space = bounds.width / CGFloat(70)
        let numberOfSquares = self.squares.count
        
        let squareWidth = ( GSWidth - CGFloat(space * CGFloat(numberOfSquares + 2)) ) / CGFloat(numberOfSquares)
        let squareSize = CGSize(width: squareWidth, height: squareWidth)
        var inset = CGFloat(space)
        
        for square in self.squares{
                
        square.frame.size = squareSize
                
            let squareX = CGFloat(GSOrigin.x + inset)
            let squareY = CGFloat(bounds.origin.y + GSHeight/2 - squareWidth/2)
            
            square.frame.origin = CGPoint(x: squareX , y: squareY)
            square.refreshLabel()
            
            inset += (squareWidth + CGFloat(space))
            }
        
        var initial = space / 2
        
        for spaceBar in self.spaceBars{
            
            let spaceBarX = CGFloat(GSOrigin.x + initial)
            let spaceBarY = CGFloat(bounds.origin.y + GSHeight/2 - squareWidth * 1.2)
            
            spaceBar.frame.size = CGSize(width: space/5, height: squareWidth * 2.4)
            
            spaceBar.frame.origin = CGPoint(x: spaceBarX, y: spaceBarY)
            
            initial += (space + squareWidth)
            
        }
        return nil
    }
    
    func generateSquares(for numbers: [Int]){
        
        let space = GSWidth / CGFloat(70)
        let squareWidth = ( GSWidth - (space * CGFloat(numbers.count + 2)) ) / CGFloat(numbers.count)
        let squareSize = CGSize(width: squareWidth, height: squareWidth)
        var inset = CGFloat(space)
        
        for i in numbers {
            
            let newViewX = CGFloat(GSOrigin.x + inset)
            let newViewY = CGFloat(bounds.origin.y + GSHeight/2 - squareWidth/2)
            let newViewOrigin = CGPoint(x: newViewX, y: newViewY)
            
            
            let newViewFrame = CGRect(origin: newViewOrigin, size: squareSize)
            let newView = Square(frame: newViewFrame, forNumber: i)
            
            self.addSubview(newView)
            self.squares.append(newView)
            
            inset += (squareWidth + CGFloat(space))
        }
        
    }
    
    func generateSpaceBars(for numbers: [Int]) {
        let space = GSWidth / CGFloat(70)
        let squareWidth = ( GSWidth - (space * CGFloat(numbers.count + 2)) ) / CGFloat(numbers.count)
        var initial = space / 2
        while initial < GSWidth {
            let newViewX = CGFloat(GSOrigin.x + initial)
            let newViewY = CGFloat(bounds.origin.y + GSHeight/2 - squareWidth * 1.2)
            let newFrame = CGRect(x: newViewX, y: newViewY , width: space/5, height: squareWidth * 2.2)
            let spaceBar = SpaceBar(frame: newFrame)
            self.addSubview(spaceBar)
            self.spaceBars.append(spaceBar)
            initial += (space + squareWidth)
        }
    }
    
    func createShadow(forSquare currentSquare: Square) throws {
        
        let initialCount = squares.count
        
        let currentFrame = currentSquare.frame
        let shadowFrame = CGRect(origin: currentFrame.origin, size: currentFrame.size)
        let shadowSquare = Square(frame: shadowFrame, forNumber: Int(currentSquare.numberLabel!.text!)!)
        shadowSquare.state = .Shadow
        self.addSubview(shadowSquare)
        self.squares.append(shadowSquare)
        
        guard squares.count - 1 == initialCount else {
            throw GameSpaceErrors.shadowSquareFail
        }
                
    }
    
    func removeShadow(){
        let shadows = self.squares.filter({$0.state == .Shadow})
        guard shadows.count == 1 else {
            return
        }
        let shadowSquare = shadows.first
        shadowSquare?.removeFromSuperview()
        squares.removeAll(where: {$0.state == .Shadow})
    }
    
    func updateSquaresArray(fromIndex from: Int, atIndex at: Int){
        
        let square = squares[from]
        squares.remove(at: from)
        squares.insert(square, at: at)
        
    }
    
    func removeSquares(){
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
    
    
}
