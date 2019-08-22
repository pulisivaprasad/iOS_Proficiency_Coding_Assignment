//
//  HomeViewController.swift
//  Proficiency_Exercise
//
//  Created by sivaprasad reddy on 22/08/19.
//  Copyright © 2019 Siva. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var dataObjArr = [DataModel]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 140
        tableView.tableFooterView = UIView()

        //Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh the data")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        //Api call calling
        getDataFromApi()
        
    }
    
    @objc func refresh() {
        getDataFromApi()
    }
    
    // MARK: Api Call
    func getDataFromApi() {
        if Helper.sharedHelper.isNetworkAvailable() {
            Helper.sharedHelper.showGlobalHUD(title: "Loding...", view: view)
            let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
            let request : URLRequest = URLRequest(url: url!)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard data != nil else { return }
                do {
                    //Data we are converting in to UTF8 data
                    let utf8Data = String(decoding: data!, as: UTF8.self).data(using: .utf8)
                    
                    let jsonData: NSMutableDictionary = try JSONSerialization.jsonObject(with: utf8Data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    
                    DispatchQueue.main.async(execute: {
                        Helper.sharedHelper.dismissHUD(view: self.view)
                        self.refreshControl.endRefreshing()
                        
                        self.title = jsonData["title"] as? String ?? ""
                        let arr = DataModel.modelsFromDictionaryArray(array: jsonData["rows"] as! NSArray)
                        self.dataObjArr = arr as [DataModel]
                        self.tableView.reloadData()
                        
                        print(jsonData)
                    })
                    
                }
                catch {
                    DispatchQueue.main.async {
                        Helper.sharedHelper.dismissHUD(view: self.view)
                    }
                    
                    print("json error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        else{
            Helper.sharedHelper.ShowAlert(str: "Please check your internet connection.", viewcontroller: self)
        }
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObjArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CCell", for: indexPath) as? CustomTableViewCell
        let dataObj = dataObjArr[indexPath.row]
        cell!.setData(dataObj: dataObj)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

