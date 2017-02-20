//
//  MoreVC.swift
//  Test
//
//  Created by Le Thi An on 12/15/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit
import CoreData

class MoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var img_avatar: UIImageView!
    @IBOutlet weak var lblusrname: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var iconImages: [UIImage] = []
    var titles: [String] = []
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "TabMoreTableViewCell", bundle: nil), forCellReuseIdentifier: "TabMoreTableViewCell")
        self.initView()
        iconImages = [UIImage(named: "ic_about")!, UIImage(named: "ic_search_favorite")!, UIImage(named: "ic_video_favorite")!, UIImage(named: "ic_music_favorite")!, UIImage(named: "ic_photo_favorite")!, UIImage(named: "ic_book_favorite")!]
        titles = ["About", "Search Favorite", "Video Favorite", "Music Favorite", "Photo Favorite", "Book Favorite"]
    }
    
    override func viewWillAppear(animated: Bool) {
//        print(list.count)
//        list = fetchAllFavoriteData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: UITableViewDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37.0
    }
    
    func tableView(tableView:UITableView, viewForHeaderInSection section:Int)-> UIView?
    {
        let headerView:UIView = UIView (frame:CGRectMake(0, 0, self.tableView.frame.size.width, 36))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(16, 0, self.tableView.frame.size.width-16, 36))
        //        label.center = CGPointMake(self.tableView.frame.size.width/2, view.frame.size.height/2)
        label.textAlignment = NSTextAlignment.Left
        label.font = ProximaNovaSemibold14
        label.text = "MENU"
        label.textColor = GRAY_9B9B9B
        headerView.addSubview(label)
        
        headerView.layer.masksToBounds = true
        headerView.layer.borderColor = GRAY_E1E1E1.CGColor
        headerView.layer.borderWidth = 0.5
        
        
        return headerView;
    }
        
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("Row \(indexPath.row) selected")
        if indexPath.row <= 5 {
            let favoriteVC = FavoriteVC()
//            let nav = UINavigationController(rootViewController: favoriteVC)
            
            let cell:TabMoreTableViewCell! = tableView.cellForRowAtIndexPath(indexPath) as! TabMoreTableViewCell
            favoriteVC.title = cell.title.text
            
            self.navigationController?.pushViewController(favoriteVC, animated: true)
        } else {
            let logoutAlert = UIAlertController(title: LOGOUT_TITLE, message: CONFIRM_LOGOUT, preferredStyle: UIAlertControllerStyle.Alert)
            
            logoutAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setInteger(0, forKey: "ISLOGGEDIN")
                prefs.synchronize()
                if let window = self.view.window {
                    window.rootViewController = ViewController()
                }
            }))
            
            logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(logoutAlert, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row <= 5 {
            let identifier = "TabMoreTableViewCell"
            var cell:TabMoreTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? TabMoreTableViewCell
            
            if cell == nil {
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TabMoreTableViewCell
                
            }
            cell.icon.image = iconImages[indexPath.row]
            cell.title.text = titles[indexPath.row]
            
            cell.layer.masksToBounds = true
            cell.layer.borderColor = GRAY_E1E1E1.CGColor
            cell.layer.borderWidth = 0.5
//            cell.selectionStyle = .None
            
            return cell
        } else {
            let cell:UITableViewCell! = UITableViewCell()
            
            let lblLogout = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, 54))
            lblLogout.textAlignment = NSTextAlignment.Center
            lblLogout.font = ProximaNovaRegular15
            lblLogout.text = "LOGOUT"
            lblLogout.textColor = RED_FF5722
            
            let bottomView = UIView(frame: CGRectMake(0, 54, tableView.frame.size.width, 0.5))
            bottomView.backgroundColor = GRAY_E1E1E1
            
            cell.addSubview(lblLogout)
            cell.addSubview(bottomView)
            
            cell.layer.masksToBounds = true
            cell.layer.borderColor = GRAY_E1E1E1.CGColor
            cell.layer.borderWidth = 0.5
//            cell.selectionStyle = .None
            
            return cell
        }
    }
    
//    MARK: init nav controller methods
    
    func initView() -> Void {
        
        self.profileView.backgroundColor = UIColor(patternImage: UIImage(named: "bg_tab_more")!)
        
        img_avatar.layer.borderWidth = 0.5
        
        img_avatar.layer.borderColor = UIColor.whiteColor().CGColor
        
        let searchBox = UIButton()
        searchBox.frame = CGRectMake(0, 0, 344, 28)
        searchBox.layer.cornerRadius = 5
        searchBox.setBackgroundImage(UIImage(named: "ic_searchbar"), forState: .Normal)
        searchBox.addTarget(self, action: "moveToSearchVC:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let subView = UIView(frame: CGRectMake(0, 0, 344, 28))
        subView.addSubview(searchBox)
        
//        navigationController?.navigationBar.addSubview(searchBox)
        navigationItem.titleView = subView
        
        navigationController?.navigationBar.barTintColor = GREEN_4CAF50
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBarHidden = false
        
    }
    
//    MARK: Actions
    
    func moveToSearchVC(sender: UIButton) {
        let searchVC = SearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
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
