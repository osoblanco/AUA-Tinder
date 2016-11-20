//
//  LoginViewController.swift
//  AUA-Tinder
//
//  Created by Erik Arakelyan on 11/20/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController, requestManagerDelegate {

    var manager:requestManager!
    var indicator: NVActivityIndicatorView!
    var userSelected:User!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    
    func fetchingFinnished(fetchedArray:Array<User>)->Void{}
    
    func startLoading()->Void{
        
        enterButton.isEnabled = false
        indicator.startAnimating()
    
    }
    func endLoading()->Void{
        
        enterButton.isEnabled = true
        indicator.stopAnimating()
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.manager = appDelegate.manager
        self.manager.delegate = self
        
        self.indicator = NVActivityIndicatorView(frame:
            CGRect(origin: CGPoint(x: self.view.center.x-50,y :self.view.center.y-50), size: CGSize(width: 100, height: 100))
            , color: UIColor.red)
        
        indicator.type = .lineScale
        indicator.color = UIColor.white
        
        if appDelegate.fullUserArray.count == 0 {
            manager.fetchAllUsers()
        }
        
        self.view.addSubview(self.indicator)
        self.navigationController?.isNavigationBarHidden = true


    }
    
    @IBAction func login(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for item in appDelegate.fullUserArray{
            if item.id == Int(self.textField.text!)
            {
                userSelected = item
                self.performSegue(withIdentifier: "profileSegue", sender: sender)
            }
        }
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "profileSegue") {
            let nextScene = segue.destination as? ViewController
            nextScene?.user = userSelected
            
                    let httpsURL = userSelected.imageURL
                    let replaced = (httpsURL as NSString).replacingOccurrences(of: "http", with: "https")
                    nextScene?.user.imageURL = replaced //got to have safe https calls
                    
            
            }
        }


}
