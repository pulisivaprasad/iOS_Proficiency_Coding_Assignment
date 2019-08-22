//
//  HomeViewControllerTests.swift
//  Proficiency_ExerciseTests
//
//  Created by sivaprasad reddy on 22/08/19.
//  Copyright © 2019 Siva. All rights reserved.
//

import XCTest
@testable import Proficiency_Exercise

class HomeViewControllerTests: XCTestCase {
    var homeVC: HomeViewController!
    var sut: URLSession!

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.homeVC = (storyboard.instantiateViewController(withIdentifier: "HVC") as! HomeViewController)
        self.homeVC.loadView()
        self.homeVC.viewDidLoad()
        
        sut = URLSession(configuration: .default)

    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testValidateApiCall() {
        let url =
            URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    guard data != nil else { return }
                    do {
                        
                        let utf8Data = String(decoding: data!, as: UTF8.self).data(using: .utf8)
                        
                        let jsonData: NSMutableDictionary = try JSONSerialization.jsonObject(with: utf8Data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                        
                        DispatchQueue.main.async(execute: {
                            Helper.sharedHelper.dismissHUD(view: self.homeVC.view)
                            self.homeVC.refreshControl.endRefreshing()
                            
                            let arr = DataModel.modelsFromDictionaryArray(array: jsonData["rows"] as! NSArray)
                            self.homeVC.dataObjArr = arr as [DataModel]
                            self.callTableViewCellForRowAtIndexPath()
                            
                            print(jsonData)
                        })
                        
                    }
                    catch {
                        DispatchQueue.main.async {
                            Helper.sharedHelper.dismissHUD(view: self.homeVC.view)
                        }
                        
                        print("json error: \(error.localizedDescription)")
                    }
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    
    func testHasATableView() {
        XCTAssertNotNil(homeVC.tableView)
    }
    
    func testTableViewConfromsToTableViewDataSourceProtocol() {
        XCTAssertTrue(homeVC.conforms(to: UITableViewDataSource.self))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(homeVC.tableView.dataSource)
    }
    
    func testNumberOfRows() {
        let tableView = UITableView()
        
        let numberOfRows = homeVC.tableView.dataSource!.tableView(tableView, numberOfRowsInSection: homeVC.dataObjArr.count)
        XCTAssertEqual(numberOfRows, homeVC.dataObjArr.count,
                       "Number of rows in table should match number of dataItems")
    }
    
    func callTableViewCellForRowAtIndexPath() {
        
        let cell = homeVC.tableView(homeVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! CustomTableViewCell

        XCTAssertNotNil(cell.titleLabel.text!)
        XCTAssertNotNil(cell.descriptionLabel.text!)

    }
 

}
