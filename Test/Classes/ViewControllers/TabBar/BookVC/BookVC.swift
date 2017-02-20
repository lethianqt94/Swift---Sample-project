//
//  BookVC.swift
//  Test
//
//  Created by Le Thi An on 12/14/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class BookVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MusicCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var btnUS: UIButton!
    var btnVN: UIButton!
    var btnKOR: UIButton!
    
    var bookList:[BookObject] = []
        
    var key:Int = 4
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        
        self.initView()
    }
    
    override func viewWillAppear(animated: Bool) {
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
        return self.bookList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let obj = self.bookList[index]
        
        let detailsWV = DetailsWebView()
        detailsWV.title = obj.name
        detailsWV.wvLink = obj.wvlink
        self.navigationController?.pushViewController(detailsWV, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        let identifier = "TableCell"
        var cell:CustomTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomTableViewCell
        
        if cell == nil {
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CustomTableViewCell
            
        }
        
        let book = self.bookList[indexPath.row]
        
        
        cell.lblTitle.text = book.name
        cell.lblSinger.text = book.author
        
        let avtlink = book.avatar_imgs[2].linkAvatar
        
        cell.imgAvatar.hnk_setImageFromURL(NSURL(string:avtlink)!, placeholder: nil, format: nil, failure: { (error) -> () in
            
            }) { (image) -> () in
                cell.imgAvatar.image = image
        }
        
        cell.imgAvatar.frame = CGRect(x: 16, y: 7, width: 46, height: 64)
        
//        cell.imgAvatar.frame.origin.y = 7
//        cell.imgAvatar.frame.size.height = 64
        
        if CommonDataFunc.isFavorite(book.author!, title: book.name!, imageLink: avtlink, key: 4) == true {
            book.isFavorite = true
        } else {
            book.isFavorite = false
        }
        
        if (book.isFavorite == true) {
            cell.btnFavorite.setImage(UIImage(named: "img_cell_normal"), forState: .Normal)
        } else {
            cell.btnFavorite.setImage(UIImage(named: "img_cell_selected"), forState: .Normal)
        }
        
        cell.musicCellDelegate = self
        cell.layer.masksToBounds = true
        cell.layer.borderColor = GRAY_E1E1E1.CGColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
//    MARK: Navigation
    
    func initView() -> Void {
        
        
        let btnLocation = UIButton()
        btnLocation.setImage(UIImage(named : "img_location"), forState: .Normal)
        btnLocation.frame = CGRectMake(341, 12, 18, 21)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnLocation
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let searchBox = UIButton()
        searchBox.frame = CGRectMake(-10, 0, 310, 28)
        searchBox.layer.cornerRadius = 5
        searchBox.setBackgroundImage(UIImage(named: "ic_searchbar"), forState: .Normal)
        searchBox.addTarget(self, action: "moveToSearchVC:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let subView = UIView(frame: CGRectMake(-10, 0, 310, 28))
        subView.addSubview(searchBox)
        
        navigationItem.titleView = subView
        
        self.navigationController?.navigationBar.barTintColor = GREEN_4CAF50
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBarHidden = false
        
        
        
        //        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor.whiteColor()
        
        let shadowPath =  UIBezierPath(rect: toolbar.bounds)
        
        toolbar.clipsToBounds = false
        toolbar.layer.shadowColor = UIColor.blackColor().CGColor
        toolbar.layer.shadowOffset = CGSizeMake(0,1);
        toolbar.layer.shadowOpacity = 0.15;
        toolbar.layer.shadowPath = shadowPath.CGPath
        
        btnUS =  UIButton(frame:CGRectMake(0, 0, 100, 21))
        btnUS.setTitle("UNITED STATE", forState: .Normal)
        btnUS.titleLabel?.font = ProximaNovaSemibold13
        btnUS.setTitleColor(RED_FF5722, forState: .Normal)
        btnUS.addTarget(self, action: "selectedUS", forControlEvents: .TouchUpInside)
        
        
        let itemUS = UIBarButtonItem()
        itemUS.customView = btnUS
        
        btnVN =  UIButton(frame:CGRectMake(0, 0, 100, 21))
        btnVN.setTitle("VIETNAM", forState: .Normal)
        btnVN.titleLabel?.font = ProximaNovaSemibold13
        btnVN.setTitleColor(BLACK_727272, forState: .Normal)
        btnVN.addTarget(self, action: "selectedVN", forControlEvents: .TouchUpInside)
        
        
        let itemVN = UIBarButtonItem()
        itemVN.customView = btnVN
        
        
        btnKOR =  UIButton(frame:CGRectMake(0, 0, 100, 21))
        btnKOR.setTitle("KOREAN", forState: .Normal)
        btnKOR.titleLabel?.font = ProximaNovaSemibold13
        btnKOR.setTitleColor(BLACK_727272, forState: .Normal)
        btnKOR.addTarget(self, action: "selectedKOR", forControlEvents: .TouchUpInside)
        
        
        let itemKOR = UIBarButtonItem()
        itemKOR.customView = btnKOR
        
        let lbl1 = UILabel(frame:CGRectMake(0, 0, 1, 21))
        lbl1.backgroundColor = UIColor.grayColor()
        
        let space1 = UIBarButtonItem()
        space1.customView = lbl1
        
        let lbl2 = UILabel(frame:CGRectMake(0, 0, 1, 21))
        lbl2.backgroundColor = UIColor.grayColor()
        
        let space2 = UIBarButtonItem()
        space2.customView = lbl2
        
        toolbar.items = [itemUS,space1,itemVN,space2,itemKOR]
        
        selectedUS()
        
    }
    
//    MARK: call api from server
    
    func callAPI(urlAsString:String){
        
        Async.main{
            CommonUIFunc.showActivityIndicator(self)
        }
        
        Alamofire.request(.GET, urlAsString, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            
            if response.result.isSuccess {
//                print("aaaaaaa")
                Async.background{
                    
                    let booklist = Mapper<BookList>().map(response.result.value!)
                    if booklist!.books != nil {
                        self.bookList = (booklist!.books)!
                    } else {
                        self.bookList = []
                    }
                    
                    }.main{
                        CommonUIFunc.hideActivityIndicator()
                        self.tableView.reloadData()
                }
            } else {
                print(response.result.error!)
            }
            
        }
    }
    
//    MARK: Button actions
    
    func selectedUS() {
        btnUS.setTitleColor(RED_FF5722, forState: .Normal)
        btnVN.setTitleColor(BLACK_727272, forState: .Normal)
        btnKOR.setTitleColor(BLACK_727272, forState: .Normal)
        callAPI("https://itunes.apple.com/us/rss/toppaidebooks/limit=100/json")
    }
    
    func selectedVN() {
        btnUS.setTitleColor(BLACK_727272, forState: .Normal)
        btnVN.setTitleColor(RED_FF5722, forState: .Normal)
        btnKOR.setTitleColor(BLACK_727272, forState: .Normal)
        callAPI("https://itunes.apple.com/vn/rss/toppaidebooks/limit=100/json")
        
    }
    
    func selectedKOR() {
        btnUS.setTitleColor(BLACK_727272, forState: .Normal)
        btnVN.setTitleColor(BLACK_727272, forState: .Normal)
        btnKOR.setTitleColor(RED_FF5722, forState: .Normal)
        callAPI("https://itunes.apple.com/kr/rss/toppaidebooks/limit=100/json")
        
    }
    
    func moveToSearchVC(sender: UIButton) {
        let searchVC = SearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
//    MARK: MusicCellDelegate method
    
    func tapToFavorite(cell: CustomTableViewCell, key: Int) {
        let index = self.tableView.indexPathForCell(cell)?.row
        let book = self.bookList[index!]
        
        if (book.isFavorite == true) {
            CommonUIFunc.simpleAlert(FAVOR_TITLE, message: ITEM_SAVED, viewController: self)
        } else {
            CommonDataFunc.saveFavoriteData(book.name!, artist: book.author!, imageLink: book.avatar_imgs[2].linkAvatar!, wvLink: book.wvlink!, key: key)
        }
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
