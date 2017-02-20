//
//  FavoriteVC.swift
//  Test
//
//  Created by Le Thi An on 12/15/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MusicCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var list:[NSManagedObject] = []
    
    var key:Int = 0
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        initNavBar()
        
//        print(getKey(self.title!))
        
        
//        print(list.count)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        txtSearch.attributedPlaceholder = NSAttributedString(string:"Search",
            attributes:[NSForegroundColorAttributeName: BLACK_585858, NSFontAttributeName: ProximaNovaRegular14!])
        
        list = CommonDataFunc.fetchFavoriteDataByType(getKey(self.title!))
        Async.main {
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: UITableViewDataSource methods
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.list.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let index = indexPath.row
        let obj = self.list[index]
        
        let detailsWV = DetailsWebView()
        detailsWV.wvLink = obj.valueForKey("webViewLink") as? String
        detailsWV.title = obj.valueForKey("title") as? String
        self.navigationController?.pushViewController(detailsWV, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        let identifier = "TableCell"
        
        var cell:CustomTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomTableViewCell
        
        if cell == nil {
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomTableViewCell
            
        }        
        
        let object = list[indexPath.row]
        
        cell.lblTitle.text = object.valueForKey("title") as? String
        cell.lblSinger.text = object.valueForKey("author") as? String
        
        
        let avtlink = object.valueForKey("imageLink") as? String
        
        cell.imgAvatar.hnk_setImageFromURL(NSURL(string:avtlink!)!, placeholder: nil, format: nil, failure: { (error) -> () in
            
            }) { (image) -> () in
                cell.imgAvatar.image = image
        }
        
        cell.musicCellDelegate = self
        cell.btnFavorite.setImage(UIImage(named: "img_delete"), forState: .Normal)
        cell.layer.masksToBounds = true
        cell.layer.borderColor = GRAY_E1E1E1.CGColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
//    MARK: Navigation controller
    
    func initNavBar() {
        
        let naviBar:UINavigationBar! = self.navigationController?.navigationBar
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named : "img_back"), forState: .Normal)
        btnBack.frame = CGRectMake(15, 13, 13, 21)
        btnBack.addTarget(self, action: "popView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnBack
        navigationItem.leftBarButtonItem = leftBarButton       
        
        
        naviBar.barTintColor = GREEN_4CAF50
        naviBar.translucent = false
        
        if let font = ProximaNovaSemibold14 {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        naviBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        let iconPaddingView = UIView(frame: CGRectMake(0, 0, 36, self.txtSearch.frame.height))
        let iconSearch = UIImageView(frame: CGRectMake(16, 14, 13, 13))
        
        iconSearch.image = UIImage(named: "icon_seach")
        iconPaddingView.addSubview(iconSearch)
        
        txtSearch.leftView = iconPaddingView
        txtSearch.leftViewMode = UITextFieldViewMode.Always
        txtSearch.backgroundColor = UIColor.whiteColor()
        
        txtSearch.layer.masksToBounds = true
        txtSearch.layer.borderColor = GRAY_E1E1E1.CGColor
        txtSearch.layer.borderWidth = 1
        
    }
    
    
//    MARK: UITextfieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.returnKeyType = UIReturnKeyType.Search
        textField.resignFirstResponder()
        
        let key = textField.text
        
        list = CommonDataFunc.fetchDataByAtrr("title", key: key!, type: getKey(self.title!))
        if textField.text == "" {
            list = CommonDataFunc.fetchFavoriteDataByType(getKey(self.title!))
            Async.main {
                self.tableView.reloadData()
            }
        } else if list.count == 0 {
            CommonUIFunc.simpleAlert("Data", message: "No data found",viewController: self)
            list = []
            Async.main{
                self.tableView.reloadData()
            }
        } else {
            Async.main{
                self.tableView.reloadData()
            }
        }
        
        return true
    }
    
//    MARK: UIView touch events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.txtSearch.resignFirstResponder()
        super.touchesBegan(touches, withEvent: event)
    }
//    "Search Favorite", "Video Favorite", "Music Favorite", "Photo Favorite", "Book Favorite"
    
    func getKey(title:String)->Int {
        switch(title) {
            case "Video Favorite":
                return 2
            case "Music Favorite":
                return 1
            case "Photo Favorite":
                return 3
            case "Book Favorite":
                return 4
            default:
                return 0
        }
    }
    
//    MARK: button actions
    
    func popView(sender: UIButton!) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
//    MARK: Protocol MusicCellDelegate method
    
    func tapToFavorite(cell: CustomTableViewCell, key: Int) {
        let index = self.tableView.indexPathForCell(cell)?.row
        
        let data:NSManagedObject = list[index!]
        
        let delConfirmAlert = UIAlertController(title: DATA_TITLE, message: CONFIRM_DEL_DATA, preferredStyle: UIAlertControllerStyle.Alert)
        
        delConfirmAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            CommonDataFunc.deleteObjData(data)
            self.list.removeAtIndex(index!)
            
            self.tableView.deleteRowsAtIndexPaths([self.tableView.indexPathForCell(cell)!], withRowAnimation: UITableViewRowAnimation.Fade)
        }))
        
        delConfirmAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        
        self.presentViewController(delConfirmAlert, animated: true, completion: nil)
        
//        self.tableView.reloadData()
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
