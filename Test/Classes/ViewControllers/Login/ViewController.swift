//
//  ViewController.swift
//  Test
//
//  Created by Le Thi An on 12/1/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mviewTop: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
//    var newConstraint = NSLayoutConstraint(item: mainView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: self.view.frame.width)
    
//    
//    MARK: Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBarHidden = true
        
        let emailPaddingView = UIView(frame: CGRectMake(0, 0, 15, self.txtEmail.frame.height))
        txtEmail.leftView = emailPaddingView
        txtEmail.leftViewMode = UITextFieldViewMode.Always
        
        let pwdPaddingView = UIView(frame: CGRectMake(0, 0, 15, self.txtPassword.frame.height))
        txtPassword.leftView = pwdPaddingView
        txtPassword.leftViewMode = UITextFieldViewMode.Always

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
//        txtEmail.becomeFirstResponder()
        
        txtEmail.placeholder = "Email"
        txtPassword.placeholder = "Password"
        txtEmail.text = ""
        txtPassword.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
//    MARK: button Login Action
//
    
    @IBAction func doLogin(sender: UIButton) {
        //self.currentTxt.endEditing(true)
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
//        check inputs
        if (isValidEmail(txtEmail.text!) && txtPassword.text != "") {
//            if incorrect input
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setInteger(1, forKey: "ISLOGGEDIN")
            prefs.synchronize()
            if let window = self.view.window {
                window.rootViewController = MusicVideoTabBar()
            }
        } else {
//            let alert = UIAlertController(title: ERROR_TITLE, message: SIGNIN_FAILED, preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            CommonUIFunc.simpleAlert(ERROR_TITLE, message: SIGNIN_FAILED, viewController: self)
//            self.presentViewController(alert, animated: true, completion: nil)
//            let tabbar = MusicVideoTabBar()
//            self.navigationController?.pushViewController(tabbar, animated: true)
        }
        
    }
    
//    
//    MARK: textfields delegate
// 
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //currentTxt = textField
        UIView.animateWithDuration(0.5) { () -> Void in
            self.mainView.frame.origin.x = 0
            self.mainView.frame.origin.y = -40
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.mainView.frame.origin.x = 0
            self.mainView.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //currentTxt.endEditing(true)
        
        if textField == self.txtEmail {
            textField.resignFirstResponder()
            self.txtPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
//    MARK: main view touch events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //currentTxt.endEditing(true)
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
    
//    MARK: support funcs
    
    func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }

}
