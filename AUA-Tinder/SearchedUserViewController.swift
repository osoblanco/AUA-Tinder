//
//  SearchedUserViewController.swift
//  AUA-Tinder
//
//  Created by Erik Arakelyan on 11/20/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit
import Koloda
import Alamofire
import pop

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1


class SearchedUserViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource {
    
    var userName:String!
    var imageURL:String!
    var gender:Int = -1
    var id:Int = -1
    
    @IBOutlet weak var kolodaView: KolodaView!
    var images: Array<UIImage> = []

    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    @IBAction func back(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    
    //Koloda dataSource
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 1
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView{

        let imageView = UIImageView(image:nil)
        imageView.downloadedFrom(link: self.imageURL)
        
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.purple
        
        return imageView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView?{
        return Bundle.main.loadNibNamed("CustomOverlayView",
                                                  owner: self, options: nil)?[0] as? CustomOverlayView
        
        
    }
    
    //Koloda delegate
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        UIApplication.shared.openURL(URL(string: "http://google.com/")!)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        kolodaView.layer.cornerRadius = 8.0
        kolodaView.clipsToBounds = true
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
        

}

