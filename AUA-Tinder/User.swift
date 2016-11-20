//
//  User.swift
//
//
//  Created by Erik Arakelyan on 11/19/16.
//
//

import UIKit

class User: NSObject {
    
    var name: String = "unknown"
    var imageURL: String = "http://auatinder.azurewebsites.net/images/2.JPEG"
    var gender:Int = -1
    var id:Int = -1
    var statusSelected:Int = -1
    init(name: String, imageURL:String, gender:Int,id:Int) {
        self.name = name
        self.imageURL = imageURL
        self.gender = gender
        self.id = id
        
    }
    
    func getname()->String
    {
        return self.name;
    }
    
    func getimageURL()->String
    {
        return self.imageURL;
    }
    
    func getgender()->Int
    {
        return self.gender;
    }
    
    func getid()->Int
    {
        return self.id;
    }
    
}
