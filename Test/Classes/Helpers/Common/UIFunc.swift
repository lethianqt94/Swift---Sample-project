//
//  CommonUIFunc.swift
//  Test
//
//  Created by Le Thi An on 12/18/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation
import UIKit

var spinner = UIActivityIndicatorView()
var loadingView: UIView = UIView()

class CommonUIFunc {
    
//extension UIViewController {

    class func simpleAlert(title:String, message:String, viewController:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showActivityIndicator(viewController:UIViewController) {
        loadingView.frame = CGRect(x: viewController.view.frame.size.width/2 - 50, y: viewController.view.frame.size.height/2 - 50, width: 100.0, height: 100.0)
        //            self.loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor.lightGrayColor()
        loadingView.alpha = 0.7
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        spinner.center = CGPoint(x:loadingView.bounds.size.width / 2, y:loadingView.bounds.size.height / 2)
        
        loadingView.addSubview(spinner)
        viewController.view.addSubview(loadingView)
        spinner.startAnimating()
    }
    
    class func hideActivityIndicator() {
        spinner.stopAnimating()
        loadingView.removeFromSuperview()
    }

    
}