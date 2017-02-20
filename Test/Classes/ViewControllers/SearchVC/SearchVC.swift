//
//  SearchVC.swift
//  Test
//
//  Created by Le Thi An on 12/18/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit
import Alamofire

class SearchVC: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var lblSearchKey: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgViewLoadMore: UIImageView!
    
    var btnNews:UIButton!
    var btnWeb:UIButton!
    var btnPhoto:UIButton!
    var btnVideo:UIButton!
    
    var tabIndex:Int = 0
    
    var currentPage:Int = 0
    
    var txtSearch:UITextField!
    var iconPaddingView:UIView!
    var iconSearch:UIImageView!
    
    let photoCell:String = "PhotoSearchCell"
    let newsCell:String = "NewsSearchCell"
    let webCell:String = "WebSearchCell"
    
    var webArray:[WebObject] = []
    var newsArray:[NewsObject] = []
    var videoArray:[VideoSearchObject] = []
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.collectionView.registerNib(UINib(nibName: "PhotoTabCustomCell", bundle: nil), forCellWithReuseIdentifier: photoCell)
        self.collectionView.registerNib(UINib(nibName: "NewsSearchCustomCell", bundle: nil), forCellWithReuseIdentifier: newsCell)
        self.collectionView.registerNib(UINib(nibName: "WebSearchCustomCell", bundle: nil), forCellWithReuseIdentifier: webCell)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imgViewLoadMore.userInteractionEnabled = true
        imgViewLoadMore.addGestureRecognizer(tapGestureRecognizer)
        
        initNav()
        initToolbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.lblSearchKey.text = ""
    }
    
//    MARK: UITableViewDataSource methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tabIndex == 0 {
            return webArray.count
        } else if tabIndex == 2 {
            return newsArray.count
        } else if tabIndex == 3 {
            return videoArray.count
        } else {
            return 5
        }
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
            if tabIndex == 1 {
                return CGSizeMake(121, 121)
            } else if tabIndex == 0 {
                return CGSizeMake(375, 166)
            } else {
                return CGSizeMake(375, 325)
            }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if tabIndex == 0 {
            let index = indexPath.row
            let obj = self.webArray[index]
            
            let detailsWV = DetailsWebView()
            detailsWV.title = obj.title
            detailsWV.wvLink = obj.url
            self.navigationController?.pushViewController(detailsWV, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
//        print(self.tabIndex)
        
        if (tabIndex == 1) {
            var cell:PhotoTabCustomCell! = collectionView.dequeueReusableCellWithReuseIdentifier(photoCell, forIndexPath: indexPath) as? PhotoTabCustomCell
            
            if cell == nil {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCell, forIndexPath: indexPath) as? PhotoTabCustomCell
            }
            return cell
        } else if (tabIndex == 0) {
            var cell:WebSearchCustomCell! = collectionView.dequeueReusableCellWithReuseIdentifier(webCell, forIndexPath: indexPath) as? WebSearchCustomCell
            
            if cell == nil {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier(webCell, forIndexPath: indexPath) as? WebSearchCustomCell
            }
            
            let web = webArray[indexPath.row]
            
            cell.lblTitle.text = web.title
            cell.lblContent.text = web.content
            
            return cell
        } else {
            var cell:NewsSearchCustomCell! = collectionView.dequeueReusableCellWithReuseIdentifier(newsCell, forIndexPath: indexPath) as? NewsSearchCustomCell
            
            if cell == nil {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier(newsCell, forIndexPath: indexPath) as? NewsSearchCustomCell
            }
            if tabIndex == 2 {
                cell.btnPlay.hidden = true
                
                let web = newsArray[indexPath.row]
                cell.lblTitle.text = web.title
                cell.lblContent.text = web.content
                let link = web.image_link
                if link != nil {
                    cell.imgViewPhoto.hnk_setImageFromURL(NSURL(string:link!)!, placeholder: nil, format: nil, failure: { (error) -> () in
                        
                        }) { (image) -> () in
                            cell.imgViewPhoto.image = image
                    }
                }
                
                
            } else {
                cell.btnPlay.hidden = false
                
                let video = videoArray[indexPath.row]
                cell.lblTitle.text = video.title
                cell.lblContent.text = video.content
                
                let videoLink = video.video_link
                if videoLink != nil {
                cell.imgViewPhoto.hnk_setImageFromURL(NSURL(string:videoLink!)!, placeholder: nil, format: nil, failure: { (error) -> () in
                    
                    }) { (image) -> () in
                        cell.imgViewPhoto.image = image
                }
                }
            }
            
            return cell
        }
        
    }
    
//    MARK: init navbar + toolbar methods
    
    func initNav() {
        
        let naviBar:UINavigationBar! = self.navigationController?.navigationBar
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named : "img_back"), forState: .Normal)
        btnBack.frame = CGRectMake(15, 13, 13, 21)
        btnBack.addTarget(self, action: "popView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnBack
        navigationItem.leftBarButtonItem = leftBarButton
        
        let btnLocation = UIButton()
        btnLocation.setImage(UIImage(named : "img_location"), forState: .Normal)
        btnLocation.frame = CGRectMake(341, 12, 18, 21)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnLocation
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        naviBar.barTintColor = GREEN_4CAF50
        naviBar.translucent = false
        naviBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        txtSearch = UITextField()
        txtSearch.frame = CGRectMake(0, 0, 281, 28)
        txtSearch.layer.cornerRadius = 5
        txtSearch.backgroundColor = GREEN_358538
        txtSearch.font = ProximaNovaSemibold14
        txtSearch.tintColor = UIColor.whiteColor()
        txtSearch.textColor = UIColor.whiteColor()
        
        txtSearch.attributedPlaceholder = NSAttributedString(string:"Search",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: ProximaNovaSemibold14!])
        
        iconPaddingView = UIView()
        iconPaddingView.frame = CGRectMake(0, 0, 115, txtSearch.frame.height)
        iconSearch = UIImageView()
        iconSearch.frame = CGRectMake(94, 6, 15, 16)
        
        iconSearch.image = UIImage(named: "icon_seach")
        iconPaddingView.addSubview(iconSearch)
        
        txtSearch.leftView = iconPaddingView
        txtSearch.leftViewMode = UITextFieldViewMode.Always
        
        txtSearch.delegate = self
        
        let subView = UIView(frame: CGRectMake(0, 0, 281, 28))
        subView.addSubview(txtSearch)
        
        navigationItem.titleView = subView
    }
    
    func initToolbar() {
        
        toolbar.barTintColor = UIColor.whiteColor()

        
        btnWeb =  UIButton(frame:CGRectMake(0, 0, 100, 21))
        btnWeb!.setTitle("WEB", forState: .Normal)
        btnWeb!.titleLabel?.font = ProximaNovaSemibold13
        btnWeb!.setTitleColor(RED_FF5722, forState: .Normal)
        btnWeb!.addTarget(self, action: "selectedWeb", forControlEvents: .TouchUpInside)
        
        
        let itemWeb = UIBarButtonItem()
        itemWeb.customView = btnWeb
        
        btnPhoto =  UIButton(frame:CGRectMake(0, 0, 100, 21))
        btnPhoto!.setTitle("PHOTOS", forState: .Normal)
        btnPhoto!.titleLabel?.font = ProximaNovaSemibold13
        btnPhoto!.setTitleColor(BLACK_727272, forState: .Normal)
        btnPhoto!.addTarget(self, action: "selectedPhoto", forControlEvents: .TouchUpInside)
        
        
        let itemPhoto = UIBarButtonItem()
        itemPhoto.customView = btnPhoto
        
        
        btnNews =  UIButton(frame:CGRectMake(0, 0, 100, 21))
        btnNews!.setTitle("NEWS", forState: .Normal)
        btnNews!.titleLabel?.font = ProximaNovaSemibold13
        btnNews!.setTitleColor(BLACK_727272, forState: .Normal)
        btnNews!.addTarget(self, action: "selectedNews", forControlEvents: .TouchUpInside)
        
        
        let itemNews = UIBarButtonItem()
        itemNews.customView = btnNews
        
        
        btnVideo =  UIButton(frame:CGRectMake(0, 0, 100, 21))
        btnVideo!.setTitle("VIDEOS", forState: .Normal)
        btnVideo!.titleLabel?.font = ProximaNovaSemibold13
        btnVideo!.setTitleColor(BLACK_727272, forState: .Normal)
        btnVideo!.addTarget(self, action: "selectedVideo", forControlEvents: .TouchUpInside)
        
        
        let itemVideo = UIBarButtonItem()
        itemVideo.customView = btnVideo
        
        let lbl1 = UILabel(frame:CGRectMake(0, 0, 1, 21))
        lbl1.backgroundColor = UIColor.grayColor()
        
        let space1 = UIBarButtonItem()
        space1.customView = lbl1
        
        let lbl2 = UILabel(frame:CGRectMake(0, 0, 1, 21))
        lbl2.backgroundColor = UIColor.grayColor()
        
        let space2 = UIBarButtonItem()
        space2.customView = lbl2
        
        let lbl3 = UILabel(frame:CGRectMake(0, 0, 1, 21))
        lbl3.backgroundColor = UIColor.grayColor()
        
        let space3 = UIBarButtonItem()
        space3.customView = lbl3
        
        toolbar.items = [itemWeb,space1,itemPhoto,space2,itemNews,space3,itemVideo]
        
        
        let srv = UIScrollView(frame: toolbar.frame)
        srv.bounds = toolbar.bounds
        srv.autoresizingMask = toolbar.autoresizingMask
        srv.showsVerticalScrollIndicator = false
        srv.showsHorizontalScrollIndicator = false
        srv.backgroundColor = UIColor.whiteColor()
        
        let superView = toolbar.superview;
        toolbar.removeFromSuperview()
        toolbar.frame = CGRectMake(0, 0, 470, toolbar.frame.size.height)
        toolbar.bounds = toolbar.frame
        srv.contentSize = toolbar.frame.size
        srv.addSubview(toolbar)
        superView!.addSubview(srv)
        
        let shadowPath =  UIBezierPath(rect: toolbar.bounds)
        
        srv.clipsToBounds = false
        srv.layer.shadowColor = UIColor.blackColor().CGColor
        srv.layer.shadowOffset = CGSizeMake(0,1);
        srv.layer.shadowOpacity = 0.15;
        srv.layer.shadowPath = shadowPath.CGPath
        
        selectedWeb()
    }
    
//    MARK: button actions
    
    func selectedWeb() {
        btnWeb.setTitleColor(RED_FF5722, forState: .Normal)
        btnPhoto.setTitleColor(BLACK_727272, forState: .Normal)
        btnNews.setTitleColor(BLACK_727272, forState: .Normal)
        btnVideo.setTitleColor(BLACK_727272, forState: .Normal)
        
        tabIndex = 0
        currentPage = 0
        if self.txtSearch.text != "" {
            callAPI(getKey(), index: currentPage, keyword: self.txtSearch.text!)
        }
    }
    
    func selectedPhoto() {
        btnWeb.setTitleColor(BLACK_727272, forState: .Normal)
        btnPhoto.setTitleColor(RED_FF5722, forState: .Normal)
        btnNews.setTitleColor(BLACK_727272, forState: .Normal)
        btnVideo.setTitleColor(BLACK_727272, forState: .Normal)
        
        tabIndex = 1
        currentPage = 0
        callAPI(getKey(), index: currentPage, keyword: self.txtSearch.text!)
    }
    
    func selectedNews() {
        btnWeb.setTitleColor(BLACK_727272, forState: .Normal)
        btnPhoto.setTitleColor(BLACK_727272, forState: .Normal)
        btnNews.setTitleColor(RED_FF5722, forState: .Normal)
        btnVideo.setTitleColor(BLACK_727272, forState: .Normal)
        
        tabIndex = 2
        currentPage = 0
        callAPI(getKey(), index: currentPage, keyword: self.txtSearch.text!)
    }
    
    func selectedVideo() {
        btnWeb.setTitleColor(BLACK_727272, forState: .Normal)
        btnPhoto.setTitleColor(BLACK_727272, forState: .Normal)
        btnNews.setTitleColor(BLACK_727272, forState: .Normal)
        btnVideo.setTitleColor(RED_FF5722, forState: .Normal)
        
        tabIndex = 3
        currentPage = 0
        callAPI(getKey(), index: currentPage, keyword: self.txtSearch.text!)
    }
    
    
    func popView(sender: UIButton!) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    func imageTapped(sender:UIImageView) {
        currentPage++
        print("current page: \(currentPage)")
        callAPI(getKey(), index: currentPage, keyword: self.txtSearch.text!)
    }
    
//    MARK: call api from server method
    
    func callAPI(key:String, index:Int, keyword:String){
        
//        let keywordStr = keyword.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        let encodeKey = URLEncoded(keyword)
        
//        print("keyword: \(keywordStr)")
        print("encodeKey: \(encodeKey)")
        
        let urlAsString:String = "https://ajax.googleapis.com/ajax/services/search/\(key)?v=1.0&q=\(encodeKey)&start=\(index)&rsz=8"
        
        print("url: " + urlAsString)
        
        Async.main{
            CommonUIFunc.showActivityIndicator(self)
        }
        
        Alamofire.request(.GET, urlAsString, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            
            if response.result.isSuccess {
//                print(response.result.value)
                Async.background{
                    if key == "news" {
                        self.newsArray = []
                        let resultList = Mapper<NewsList>().map(response.result.value!)
                        if resultList!.list != nil {
                            self.newsArray = (resultList!.list)!
                        } else {
                            self.newsArray = []
                        }
                    } else if key == "web" {
                        self.webArray = []
                        let resultList = Mapper<WebList>().map(response.result.value!)
                        
                        if resultList!.list != nil {
                            self.webArray = (resultList!.list)!
                        } else {
                            self.webArray = []
                        }
                    } else if key == "video" {
                        self.videoArray = []
                        let resultList = Mapper<VideoSearchList>().map(response.result.value!)
                        if resultList!.list != nil {
                            self.videoArray = (resultList!.list)!
                        } else {
                            self.videoArray = []
                        }
                    } else {
                        //photo
                    }
                    
                    }.main{
                        CommonUIFunc.hideActivityIndicator()
                        self.collectionView.reloadData()
                }
            } else {
                print(response.result.error!)
            }
            
        }
    }
    
//    MARK: UITextfieldDelegate methods
    
    func textFieldDidEndEditing(textField: UITextField) {

            self.iconPaddingView.frame =  CGRectMake(0, 0, 115, self.txtSearch.frame.height)
            self.iconSearch.frame = CGRectMake(94, 6, 15, 16)

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {

            self.iconPaddingView.frame =  CGRectMake(0, 0, 19, self.txtSearch.frame.height)
            self.iconSearch.frame = CGRectMake(3, 6, 15, 16)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.returnKeyType = UIReturnKeyType.Search

        if textField.text! == "" {
            CommonUIFunc.simpleAlert(ERROR_TITLE, message: NO_SEARCH_KEY, viewController: self)
        } else {
            print(getKey())
            print(textField.text!)
            callAPI(getKey(), index: 0, keyword: textField.text!)
        }
        
        self.lblSearchKey.text = "\"" + (textField.text?.uppercaseString)! + "\""
        self.txtSearch.resignFirstResponder()
        return true
    }
    
//    MARK: support functions
    
    func getKey()->String {
        print(tabIndex)
        switch tabIndex {
        case 0:
            return "web"
        case 1:
            return "images"
        case 2:
            return "news"
        case 3:
            return "video"
        default:
            return ""
        }
    }
    
    func URLEncoded(str: String) -> String {
        
        let characters = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        
        characters.removeCharactersInString("&")
        
        guard let encodedString = str.stringByAddingPercentEncodingWithAllowedCharacters(characters) else {
            return str
        }
        
        return encodedString
        
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
