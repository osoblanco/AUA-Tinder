//
//  requestManager.swift
//  AUA-Tinder
//
//  Created by Erik Arakelyan on 11/20/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit
import Alamofire
protocol requestManagerDelegate: class {
    func fetchingFinnished(fetchedArray:Array<User>)->Void
    func startLoading()->Void
    func endLoading()->Void
}

class requestManager: NSObject {
    
    var baseURL:String
    weak var delegate:requestManagerDelegate?

    init(URL:String)
    {
        baseURL = URL
    }
    
    func fetchAllUsers() -> Void {
        
        self.delegate?.startLoading()
        
        var jsonArray:NSMutableArray?
        var newArray: Array<User> = []
        Alamofire.request(baseURL+"_",encoding: URLEncoding.default)
            
            .validate()
            
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    // completion(nil)
                    return
                }
                
                print(" \(response.result.value)")
                
                
                if let JSON = response.result.value {
                    jsonArray = JSON as? NSMutableArray
                    for item in jsonArray! {
                        let string = item as? NSDictionary
                        
                        let name = string?["Name"] as! String
                        let imageURL = string?["image"] as! String
                        let id = string?["Id"] as! Int
                        let gender = string?["gender"] as! Int
                        newArray.append( User(name:name, imageURL:imageURL, gender:gender, id:id) )
                        
                        
                    }
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.fullUserArray = newArray
                self.delegate?.endLoading()

        }
        
    }
    
    
    func fetchUserWithName(name:String) -> Void {
        
        self.delegate?.startLoading()

        var jsonArray:NSMutableArray?
        var newArray: Array<User> = []
        
        let newName = name.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        let url = baseURL + newName
        
        Alamofire.request(url,encoding: URLEncoding.default)
            
            .validate()
            
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    // completion(nil)
                    return
                }
                
                print(" \(response.result.value)")
                
                
                if let JSON = response.result.value {
                    jsonArray = JSON as? NSMutableArray
                    
                    if jsonArray != nil{
                        for item in jsonArray! {
                            let string = item as? NSDictionary
                            
                            let name = string?["Name"] as! String
                            let imageURL = string?["image"] as! String
                            let id = string?["Id"] as! Int
                            let gender = string?["gender"] as! Int
                            newArray.append( User(name:name, imageURL:imageURL, gender:gender, id:id) )
                            
                        }
                    }
                }
                self.delegate?.endLoading()
                self.delegate?.fetchingFinnished(fetchedArray: newArray)
                
        }
        
    }



}
