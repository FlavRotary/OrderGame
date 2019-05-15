//
//  IdleScreenViewController.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 23/04/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class IdleScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SendScoreDelegate , ScoreCellDelegate{
    
    @IBOutlet weak var scoresTable: UITableView!
    @IBOutlet weak var backGroundButton: UIButton!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var scores: [Score] = []
    var defaultTextLabel = "* touch anywhere to start"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createButton()
        
    }
    
    func loadData() {
        
        loadingView.type = .ballScaleRippleMultiple
        loadingView.startAnimating()
        
        HttpManager.sharedManager.fetchHighScores(10) { (scores, error) in
            
            self.loadingView.stopAnimating()
            
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let button = UIAlertAction(title: "Ok", style: .default, handler: { (acion) in
                })
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.scores = scores!
            self.scoresTable.reloadData()
        }
    }
    
    func createButton(){
        self.backGroundButton.addTarget(self, action: #selector(presentGame), for: .touchUpInside)
    }
    
    @objc func presentGame(){
        let gameScreenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameScreenViewController") as! GameScreenViewController
        gameScreenVC.delegate = self
        self.present(gameScreenVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ScoreCell", owner: self, options: nil)?.first as! ScoreCell
        cell.delegate = self
        cell.setTime(scores[indexPath.row].value)
        if cell.canBeModified == false {
            cell.name.isUserInteractionEnabled = false
            cell.setName(scores[indexPath.row].name)
        }
        return cell
    }
    
    func recieveScore(score: Int) {
        let recievedScore = score
        print(recievedScore)
        var isHighScore = false
        var currentIndex = 0
        for (index,score) in scores.enumerated(){
            if recievedScore < Int(score.value)!{
                isHighScore = true
                currentIndex = index
                break
            }
        }
        print(isHighScore)
        if isHighScore == true{
            
            let newScore = Score("\(recievedScore)")
            
            scores.insert(newScore, at: currentIndex)
            scores.removeLast()
            scoresTable.reloadData()
            keyboardOn(forCell: currentIndex)
        }
        
    }
    
    func keyboardOn(forCell cellNo: Int){
        let cell = scoresTable.cellForRow(at: IndexPath.init(row: cellNo, section: 0)) as! ScoreCell
        cell.canBeModified = true
        cell.name.becomeFirstResponder()
        infoLabel.text = "* enter hiscore name"
        self.backGroundButton.isEnabled = false
    }

    func nameDidEndEditing(text: String, cell: ScoreCell) {
        
        if let indexPath = scoresTable.indexPath(for: cell){
            scores[indexPath.row].name = text
            HttpManager.sharedManager.sendHighScore(scores[indexPath.row])
        }
        infoLabel.text = defaultTextLabel
        self.backGroundButton.isEnabled = true
    }
    
}

