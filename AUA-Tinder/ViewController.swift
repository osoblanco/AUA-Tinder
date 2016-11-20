//
//  ViewController.swift
//  AUA-Tinder
//
//  Created by Erik Arakelyan on 11/19/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CircleMenu
class ViewController: UIViewController, requestManagerDelegate,CircleMenuDelegate {
    
    var shouldShowSearchResults = false
    var indicator:NVActivityIndicatorView!
    var manager:requestManager!
    var user:User!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    
    func fetchingFinnished(fetchedArray:Array<User>)->Void{}
    
    func startLoading()->Void{indicator.startAnimating()}
    func endLoading()->Void{indicator.stopAnimating()}
    
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int)
    {
        
        let items: [(icon: String, color: UIColor)] = [
            ("icon_home", UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
            ("icon_search", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
            ("notifications-btn", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
            ("settings-btn", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
            ("nearby-btn", UIColor(red:1, green:0.39, blue:0, alpha:1)),
            ]
        
        button.backgroundColor = items[atIndex].color
        
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        
}
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        if atIndex == 0{
            toTinder(self)
        }
        if atIndex == 1{
        toSearch(self)
        }
    
    }
    

    @IBAction func toSearch(_ sender: Any) {
        
        self .performSegue(withIdentifier: "searchSegue", sender: sender)
    }
    
    @IBAction func toTinder(_ sender: Any) {
        
        self .performSegue(withIdentifier: "tinderSegue", sender: sender)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true

        self.nameLabel.text = "Name: " + user.name
        
        if(user.gender == 0){self.genderLabel.text = "Gender: Female"}
        if(user.gender == 1){self.genderLabel.text = "Gender: Male"}
        if(user.gender == 2){self.genderLabel.text = "Gender: Unknown"}
        
        profileImage.downloadedFrom(link: user.imageURL)
        
        profileImage.layer.cornerRadius = 50.0
        profileImage.clipsToBounds = true
       // profileImage.backgroundColor = UIColor.purple

        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.manager = appDelegate.manager
        self.manager.delegate = self
        
        self.indicator = NVActivityIndicatorView(frame:
            CGRect(origin: CGPoint(x: self.view.center.x-50,y :self.view.center.y-50), size: CGSize(width: 100, height: 100))
            , color: UIColor.red)
        
        indicator.type = .lineScale
        indicator.color = UIColor.white
        
        /*
        if appDelegate.fullUserArray.count == 0 {
            manager.fetchAllUsers()
        }
        */
        
        self.view.addSubview(self.indicator)
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

