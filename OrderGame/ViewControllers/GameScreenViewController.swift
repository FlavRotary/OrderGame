//
//  GameScreenViewController.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 07/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import UIKit

protocol SendScoreDelegate {
    func recieveScore(score: Int)
}

class GameScreenViewController: UIViewController {

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var gameSpace: GameSpace!
    
    var currentSeconds: Int = 0
    var timer: Timer?
    var game: Game?
    
    var delegate: SendScoreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createGame()
    }
    
    func createGame(for interval: Double = 1.0) {
        
        guard game == nil else {
            print("Game has already started! ")
            return
        }
        
        self.game = Game()
        
        let error = gameSpace.createSpace(for: game!.numbers)
        guard error == nil else {
            createAndDisplayAlert(title: "Error!", Message: error?.localizedDescription ?? "Error with Creating", Button: "Ok")
            return
        }
        
        guard timer == nil else {
            print("A timer has already been fired! ")
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
            
            self.checkStatus()
            self.currentSeconds += Int(interval)
            self.timeLabel.text = "- \(self.currentSeconds) seconds -"
        })
        
    }
    
    func checkStatus() {
        guard game != nil else {
            print("Game has not started")
            return
        }
        game?.checkItems()
        guard game?.isOver != true else {
            stopGame()
            return
        }
    }
    
    func stopGame(){
        game = nil
        timer?.invalidate()
        timer = nil
        
//        self.createAndDisplayAlert(title: "Congrats! ", Message: "You have just finished the game within: \(currentSeconds) seconds ", Button: "Great!")
        let alert = UIAlertController(title: "Congrats! ", message: "You have just finished the game within: \(currentSeconds) seconds ", preferredStyle: .alert)
        let button = UIAlertAction(title: "Great!", style: .default, handler: { (action) in
            if let delegate = self.delegate{
                delegate.recieveScore(score: self.currentSeconds)
                self.dismiss(animated: true, completion: nil)
            }
        })
        alert.addAction(button)
        self.present(alert, animated: true)
    }
    
    func checkOrientation(){
        if (UIDevice.current.orientation.isPortrait == true){
            createAndDisplayAlert(title: "Warning", Message: "For your well being and sanity, please rotate the device and play in Landscape Mode", Button: "Ok")
        }
    }
    
    // MARK: Screen Orientation Transition
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.checkOrientation()
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let error = self.gameSpace!.translateSquares()
            guard error == nil else {
                self.createAndDisplayAlert(title: "Error!", Message: error?.localizedDescription ?? "Error with Creating GameSpace", Button: "Ok")
                return
            }
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: Touch Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard ((touch?.view as? Square) != nil) else {
            return
        }
        
        if (gameSpace?.squares.contains((touch?.view)! as! Square))!{
            let currentSquare = touch?.view as! Square
            let touchLocation = (touch?.location(in: self.gameSpace))!
            currentSquare.state = .Selected
            currentSquare.setOldCoordinates(point: currentSquare.frame.origin ,touchPoint: touchLocation)
            try! gameSpace.createShadow(forSquare: currentSquare)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard ((touch?.view as? Square) != nil) else {
            return
        }
        
        if gameSpace.squares.contains((touch?.view)! as! Square){
            
            let currentSquare = touch?.view as! Square
            let touchLocation = touch?.location(in: self.gameSpace)
            var newFrame = currentSquare.frame
            
            let marginX = currentSquare.oldCoordinates!.x - currentSquare.touchedCoordinates!.x
            let marginY = currentSquare.oldCoordinates!.y - currentSquare.touchedCoordinates!.y
            
            let newX = touchLocation?.x
            let newY = touchLocation?.y
            newFrame.origin = CGPoint(x: newX! + marginX, y: newY! + marginY)
            currentSquare.frame = newFrame
            
            for spaceBar in gameSpace.spaceBars{
                if (currentSquare.frame.intersects(spaceBar.frame)) {
                    spaceBar.status = .activated
                } else {
                    spaceBar.status = .deactivated
                }
            }
        }
        
        gameSpace.isUserInteractionEnabled = false
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchedViews = gameSpace.squares.filter({$0.state == .Selected })
        guard touchedViews.count == 1 else{
            gameSpace.isUserInteractionEnabled = true
            return
        }
        
        let touchedSquare = touchedViews.first
        var squareIndex = 0
        while (touchedSquare != gameSpace.squares[squareIndex]){
            squareIndex += 1
        }
        
        let spaceBarsActivated = gameSpace.spaceBars.filter({$0.status == .activated})
        
        guard spaceBarsActivated.count == 1 else {
            UIView.animate(withDuration: 1.0, animations: {
                self.gameSpace.removeShadow()
                touchedSquare!.state = .Normal
                touchedSquare!.frame.origin = touchedSquare!.oldCoordinates!
            })
            gameSpace.isUserInteractionEnabled = true
            return
        }
        
        let spaceBar = spaceBarsActivated.first
        var spaceBarIndex = 0
        while(spaceBar != gameSpace.spaceBars[spaceBarIndex]){
            spaceBarIndex += 1
        }
        
        if squareIndex != spaceBarIndex && squareIndex != (spaceBarIndex - 1) {
            self.gameSpace.removeShadow()
            spaceBar?.status = .deactivated
            
            //
            //MARK : IF IS MOVED TO THE LEFT
            if squareIndex > spaceBarIndex{
                
                UIView.animate(withDuration: 1.0, animations: {
                    touchedSquare!.state = .Normal
                    touchedSquare!.frame.origin = self.gameSpace.squares[spaceBarIndex].frame.origin
                    var currentIndex = spaceBarIndex
                    while currentIndex != squareIndex {
                        if currentIndex + 1 == squareIndex{
                            self.gameSpace.squares[currentIndex].frame.origin = touchedSquare!.oldCoordinates!
                        } else {
                            self.gameSpace.squares[currentIndex].frame.origin = self.gameSpace.squares[currentIndex + 1].frame.origin
                        }
                        currentIndex += 1
                    }
                    self.gameSpace.updateSquaresArray(fromIndex: squareIndex, atIndex: spaceBarIndex)
                    try! self.game?.moveItem((self.game?.numbers[squareIndex])!, spaceBarIndex)
                })
                
             
            //
            //MARK: IF IS MOVED TO THE RIGHT
                
            } else {
                UIView.animate(withDuration: 1.0, animations: {
                    touchedSquare!.state = .Normal
                    touchedSquare!.frame.origin = self.gameSpace.squares[spaceBarIndex-1].frame.origin
                    var currentIndex = spaceBarIndex - 1
                    while currentIndex != squareIndex {
                        if currentIndex - 1 == squareIndex{
                            self.gameSpace.squares[currentIndex].frame.origin = touchedSquare!.oldCoordinates!
                        } else {
                            self.gameSpace.squares[currentIndex].frame.origin = self.gameSpace.squares[currentIndex - 1].frame.origin
                        }
                        currentIndex -= 1
                    }
                    self.gameSpace.updateSquaresArray(fromIndex: squareIndex, atIndex: spaceBarIndex-1)
                   try! self.game?.moveItem((self.game?.numbers[squareIndex])!, spaceBarIndex-1)
                })
            }
            
            gameSpace.isUserInteractionEnabled = true
            self.checkStatus()
            
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.gameSpace.removeShadow()
                touchedSquare!.state = .Normal
                touchedSquare!.frame.origin = touchedSquare!.oldCoordinates!
            })
            gameSpace.isUserInteractionEnabled = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
