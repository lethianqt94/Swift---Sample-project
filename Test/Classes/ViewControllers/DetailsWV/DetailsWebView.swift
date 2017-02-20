//
//  Screen2VC.swift
//  Test
//
//  Created by Le Thi An on 12/2/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit

class DetailsWebView: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var wview: UIWebView!
    var wvLink:String?
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        
        wview.scrollView.contentInset = UIEdgeInsetsZero
        wview.scalesPageToFit = true
        print("first wv link:", self.wvLink)
        
        let index = wvLink!.rangeOfString("?", options: .BackwardsSearch)?.startIndex
        if index != nil  {
            self.wvLink = wvLink!.substringToIndex(index!)
        }
        
        print("wv link:", self.wvLink)
        
        let myURL = NSURL(string: wvLink!);
        let myURLRequest:NSURLRequest = NSURLRequest(URL: myURL!);
        
        wview.loadRequest(myURLRequest)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: navi controller init methods
    
    func initView() {
    
        let naviBar:UINavigationBar! = self.navigationController?.navigationBar
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named : "img_back"), forState: .Normal)
        btnBack.frame = CGRectMake(15, 13, 13, 21)
        btnBack.addTarget(self, action: "popView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnBack
        navigationItem.leftBarButtonItem = leftBarButton
        //        self.navigationController?.navigationItem.backBarButtonItem = leftBarButton
        
        
        
        naviBar.barTintColor = GREEN_4CAF50
        naviBar.translucent = false
        
        if let font = ProximaNovaSemibold14 {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        naviBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]        
    
    }
    
//    MARK: button Acton
    func popView(sender: UIButton!) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

//    MARK: Webview delegate methods
    
    func webViewDidStartLoad(webView: UIWebView) {
//        print("start : ", webView.request)
        CommonUIFunc.showActivityIndicator(self)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
//        print("finish: ", webView.request)
        CommonUIFunc.hideActivityIndicator()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
