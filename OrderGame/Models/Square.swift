//
//  Square.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 09/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import UIKit

enum SquareState: String {
    case Selected
    case Normal
    case Shadow
}

class Square: UIView {

    var numberLabel: UILabel?
    var state: SquareState? {
        didSet{
            let currentState = state
            switch currentState{
            case .Selected? : makeSelected()
            case .Shadow? : makeShadow()
            default: makeNormal()
            }
        }
    }
    
    var oldCoordinates: CGPoint?
    var touchedCoordinates: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, forNumber number: Int) {
        self.init(frame: frame)
        createLabel(for: number)
        changeState(withState: .Normal)
    }
    
    func createLabel(for number: Int){
        
        numberLabel = UILabel(frame: CGRect.zero)
        numberLabel?.frame.size = self.frame.size
        numberLabel?.frame.origin = self.bounds.origin
        numberLabel?.font = UIFont(name: "Menlo", size: frame.width / CGFloat(2.0) )
        numberLabel?.textAlignment = .center
        numberLabel?.text = "\(number)"
        self.addSubview(numberLabel!)
    }
    
    func refreshLabel(){
        numberLabel?.frame.size = self.frame.size
        numberLabel?.frame.origin = self.bounds.origin
        numberLabel?.font = UIFont(name: "Menlo", size: frame.width / CGFloat(1.5) )
    }
    
    func changeState(withState newState: SquareState){
        self.state = newState
    }
    
    func makeNormal(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = CGFloat(10)
        self.numberLabel?.textColor = UIColor.white
        
    }
    func makeSelected(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 245/255, green: 255/255, blue: 24/255, alpha: 1.0).cgColor
        self.layer.cornerRadius = CGFloat(10)
        self.numberLabel?.textColor = UIColor(red: 245/255, green: 255/255, blue: 24/255, alpha: 1.0)
    }
    func makeShadow(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = CGFloat(10)
        self.numberLabel?.textColor = UIColor.gray
    }
    
    
    func setOldCoordinates(point: CGPoint, touchPoint: CGPoint){
        self.oldCoordinates = point
        self.touchedCoordinates = touchPoint
    }
    
    func moveBackToOriginalPlace(){
        var currentX = frame.origin.x
        var currentY = frame.origin.y
        
        while (currentX != oldCoordinates?.x){
            currentX -= CGFloat(1)
        }
        
        while (currentY != oldCoordinates?.y){
            currentY -= CGFloat(1)
        }
    }

}
