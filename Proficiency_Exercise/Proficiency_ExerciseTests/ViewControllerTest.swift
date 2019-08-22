//
//  ViewControllerTest.swift
//  Proficiency_ExerciseTests
//
//  Created by sivaprasad reddy on 21/08/19.
//  Copyright © 2019 Siva. All rights reserved.
//

import XCTest
@testable import Proficiency_Exercise

class ViewControllerTest: XCTestCase {
    var viewControllerUnderTest: ViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = (storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        self.viewControllerUnderTest.loadView()
        self.viewControllerUnderTest.viewDidLoad()
        self.viewControllerUnderTest.getDataFromApi()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }
    
    func testApiCall() {
        if Helper.sharedHelper.isNetworkAvailable() {
            Helper.sharedHelper.showGlobalHUD(title: "Loding...", view: viewControllerUnderTest.view)
            let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
            let request : URLRequest = URLRequest(url: url!)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard data != nil else { return }
                do {
                    
                    let utf8Data = String(decoding: data!, as: UTF8.self).data(using: .utf8)
                    
                    let jsonData: NSMutableDictionary = try JSONSerialization.jsonObject(with: utf8Data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    
                    DispatchQueue.main.async(execute: {
                        Helper.sharedHelper.dismissHUD(view: self.viewControllerUnderTest.view)
                        self.viewControllerUnderTest.refreshControl.endRefreshing()
                        
                        let arr = DataModel.modelsFromDictionaryArray(array: jsonData["rows"] as! NSArray)
                        self.viewControllerUnderTest.dataObjArr = arr as [DataModel]
                        //self.tableView.reloadData()
                        self.cellTableViewCellHasReuseIdentifier()
                        print(jsonData)
                    })
                    
                }
                catch {
                    DispatchQueue.main.async {
                        Helper.sharedHelper.dismissHUD(view: self.viewControllerUnderTest.view)
                    }
                    
                    print("json error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        else{
            Helper.sharedHelper.ShowAlert(str: "Please check your internet connection.", viewcontroller: viewControllerUnderTest)
        }
        
    
    }
    
    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest.tableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewConfromsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.dataSource)
    }
    
   
    func cellTableViewCellHasReuseIdentifier() {
        let cell = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: self.viewControllerUnderTest.dataObjArr.count, section: 0)) as? CustomTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "CCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
