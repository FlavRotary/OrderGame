//
//  JsonManager.swift
//  OrderGame
//
//  Created by Flavian Rotaru on 06/05/2019.
//  Copyright © 2019 Flavian Rotaru. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum HTTPErrors: String, Error {
    case urlContructionFailed = "Bad URL"
    case dataIsEmpty = "EmptyData"
}

class HttpManager {
    
    public static var sharedManager = HttpManager()
    
    func fetchHighScores(_ numberOfElements: Int = 10, completion: @escaping ([Score]?, Error?) -> Void ) {
        
            guard let url = URL(string: "https://development.m75.ro/test_mts/public/highscore/\(numberOfElements)") else {
                    completion(nil,HTTPErrors.urlContructionFailed)
                return
            }
            Alamofire.request(url)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil,response.error)
                    return
                }
                
                let fetchedData = JSON(response.data!)
                guard fetchedData.count != 0  else {
                    completion(nil,HTTPErrors.dataIsEmpty)
                    return
                }
                
                guard fetchedData["error"].isEmpty else {
                    let reportedError = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: fetchedData["error"].string!])
                    completion(nil,reportedError)
                    return
                }
                let data = fetchedData["result"].array

                var gotScores : [Score] = []

                for item in data! {
                    let newScore = Score(item["id"].string!, item["name"].string!, item["value"].string!)
                    gotScores.append(newScore)
                    }
                    completion(gotScores,nil)
            }
    }
    
    func sendHighScore(_ score: Score){
        guard let url = URL(string: "https://development.m75.ro/test_mts/public/highscore/" ) else {
            print(HTTPErrors.urlContructionFailed)
            return
        }
        
        let parameters: Parameters = ["name": score.name!,
                                      "value": Double(score.value!)!]
        
        
        Alamofire.request(url, method: .post, parameters: parameters).responseString{ response in
            guard response.result.isSuccess == true else {
                print(response.result.value!)
                return
            }
        }
    
    }
    
    
}
