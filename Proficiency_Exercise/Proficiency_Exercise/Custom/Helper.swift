//
//  Helper.swift
//  Proficiency_Exercise
//
//  Created by sivaprasad reddy on 21/08/19.
//  Copyright © 2019 Siva. All rights reserved.
//

import UIKit

class Helper: NSObject {
    static let sharedHelper = Helper()
    var appDel : AppDelegate;
    
    override init() {
        
        self.appDel = UIApplication.shared.delegate as! AppDelegate
    }
    
    func showGlobalAlertwithMessage(_ str : String) {
        
        DispatchQueue.main.async(execute: {
            let window:UIWindow = UIApplication.shared.windows.last!
            let alertView = UIAlertController(title: "Alert", message: str as String, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            window.rootViewController!.present(alertView, animated: true, completion: nil)
        })
    }
    
    func showGlobalAlertwithMessage(_ str : String, vc: UIViewController, completion: (() -> Swift.Void)? = nil) {
        
        DispatchQueue.main.async(execute: {
            let alertView = UIAlertController(title: "Alert", message: str as String, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: {             alert -> Void in
                
                completion?()
            }))
            vc.present(alertView, animated: true, completion: nil)
        })
    }
    
    
    func showGlobalHUD(title:NSString , view:UIView)
    {
        let HUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD.label.text = title as String
    }
    
    func dismissHUD(view:UIView)
    {
        MBProgressHUD.hide(for: view, animated: true)
        
    }
    
    func isNetworkAvailable() -> Bool
    {
        let rechability = Reachability()
        
        if (rechability?.isReachable)!
        {
            return true
        }
        else
        {
            return false
        }
    }

    func ShowAlert(str : NSString , viewcontroller:UIViewController) {
        let alertView = UIAlertController(title: "Alert", message: str as String, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewcontroller.navigationController?.present(alertView, animated: true, completion: nil)
    }
    
}
