//
//  SearchTableViewController.swift
//  AUA-Tinder
//
//  Created by Erik Arakelyan on 11/19/16.
//  Copyright © 2016 Erik Arakelyan. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SearchTableViewController: UITableViewController, UISearchResultsUpdating,requestManagerDelegate{

    let searchController = UISearchController(searchResultsController: nil)
    var tableData: Array<String> = []
    
    var filteredData:[String] = []
    var resultSearchController:UISearchController!
    var fullUserArray: Array<User> = []
    var manager:requestManager!
    var indicator: NVActivityIndicatorView!
    var userNameSelected:String!
    
    //Mark - manager delegate functions
    
    func fetchingFinnished(fetchedArray: Array<User>) {
        
        let fetch = fetchedArray
        for item in fetch
        {
            filteredData.append(item.name)
        }
        
        tableView.reloadData()
    }
    
    func startLoading(){
    self.indicator.startAnimating()
        searchController.isEditing = false
    }
    
    func endLoading(){
        self.indicator.stopAnimating()
        searchController.isEditing = true

    }
    //Searchbar functions
    
    func updateSearchResults(for searchController: UISearchController){
    
        if (searchController.searchBar.text?.characters.count)! > 0 {
            /*
            filteredData.removeAll(keepingCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", searchController.searchBar.text!)
            let array = (tableData as NSArray).filtered(using: searchPredicate)
            filteredData = array as! [String]
            tableView.reloadData()
             */
            
            filteredData.removeAll(keepingCapacity: false)
            manager.fetchUserWithName(name:searchController.searchBar.text!)

            
        }
        else {
            filteredData.removeAll(keepingCapacity: false)
            filteredData = tableData
            tableView.reloadData()
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(true)

        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        self.navigationController?.isNavigationBarHidden = false

        self.indicator = NVActivityIndicatorView(frame:
            CGRect(origin: CGPoint(x: self.view.center.x-50,y :self.view.center.y-100), size: CGSize(width: 100, height: 100))
            , color: UIColor.red)
        
        self.view.addSubview(self.indicator)

        indicator.type = .lineScale
        indicator.color = UIColor.red
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.manager = appDelegate.manager
        self.manager.delegate = self
        self.fullUserArray = appDelegate.fullUserArray
        
        for item in fullUserArray
        {
            tableData.append(item.name)
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
      
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if resultSearchController.isActive {
            return filteredData.count
        }
        else {
            return tableData.count
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        if resultSearchController.isActive {
            cell.textLabel?.text = filteredData[indexPath.row]
        }
        else {
            cell.textLabel?.text = tableData[indexPath.row]
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        self.userNameSelected = cell?.textLabel?.text
        self.performSegue(withIdentifier: "searchedSegue", sender: self)
        resultSearchController.isActive = false
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "searchedSegue") {
            let nextScene = segue.destination as? SearchedUserViewController
            nextScene?.userName = userNameSelected
            
            for item in fullUserArray{
                if item.name == userNameSelected{
                    
                    
                    let httpsURL = item.imageURL
                    let replaced = (httpsURL as NSString).replacingOccurrences(of: "http", with: "https")
                    nextScene?.imageURL = replaced //got to have safe https calls
                    
                    nextScene?.gender = item.gender
                    nextScene?.id = item.id
                }
            }

        }
    }

}


