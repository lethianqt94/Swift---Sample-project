//
//  VideoVC.swift
//  Test
//
//  Created by Le Thi An on 12/3/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
class VideoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, VideoCellDelegate {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var btnUS: UIButton!
    var btnVN: UIButton!
    var btnKOR: UIButton!
    
    var videos:[VideoObject] = []
//    
//    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//    var loadingView: UIView = UIView()
    
    var key:Int = 2
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.collectionView.registerNib(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        self.initView()
        selectedUS()
    }
    
    override func viewWillAppear(animated: Bool) {
        Async.main{
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: UICollectionViewDataSource methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "CollectionCell"
        
        var cell:CustomCollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? CustomCollectionViewCell
        
        if cell == nil {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? CustomCollectionViewCell
        }
        
        cell.videoDel = self
        
        let video = self.videos[indexPath.row]

        cell.lblDuration.text = convertTimeText(video.duration[1].duration)
        cell.lblDetails.text = video.title
        
        let avtlink = video.cover_imgs[2].linkAvatar
        
        cell.imgAvatar.hnk_setImageFromURL(NSURL(string:avtlink!)!, placeholder: nil, format: nil, failure: { (error) -> () in
            
            }) { (image) -> () in
                cell.imgAvatar.image = image
        }
        
        if CommonDataFunc.isFavorite(video.artist!, title: video.vid_name!, imageLink: avtlink, key: 2) == true {
            video.isFavorite = true
        } else {
            video.isFavorite = false
        }
        
        if (video.isFavorite == true) {
            cell.btnAddCollection.setImage(UIImage(named: "ic_addedcollection"), forState: .Normal)
        } else {
            cell.btnAddCollection.setImage(UIImage(named: "ic_addedcollection_2"), forState: .Normal)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let obj = self.videos[index]
        
        let detailsWV = DetailsWebView()
//        detailsWV.title = obj.valueForKey("name") as? String
        detailsWV.title = obj.vid_name
        detailsWV.wvLink = obj.wvlink
        self.navigationController?.pushViewController(detailsWV, animated: true)
    }
    
    
//    MARK: custom Navigation
    
    func initView() -> Void {
        navigationController?.navigationBarHidden = true
        
        let btnLocation = UIButton()
        btnLocation.setImage(UIImage(named : "img_location"), forState: .Normal)
        btnLocation.frame = CGRectMake(341, 12, 18, 21)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnLocation
        navigationItem.rightBarButtonItem = rightBarButton
        
        let searchBox = UIButton()
        searchBox.frame = CGRectMake(-10, 0, 310, 28)
        searchBox.layer.cornerRadius = 5
        searchBox.setBackgroundImage(UIImage(named: "ic_searchbar"), forState: .Normal)
        searchBox.addTarget(self, action: "moveToSearchVC:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let subView = UIView(frame: CGRectMake(-10, 0, 310, 28))
        subView.addSubview(searchBox)
        
        navigationItem.titleView = subView
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBarHidden = false
        
        
        
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
    }
    
//    MARK: call api from server
    
    func getJSONData(urlAsString:String){
        
        Async.main{
            CommonUIFunc.showActivityIndicator(self)
        }
        
        Alamofire.request(.GET, urlAsString, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            
            if response.result.isSuccess {
                
                Async.background{
                    
                    let videolist = Mapper<VideoList>().map(response.result.value!)
                    if videolist!.videos != nil {
                        self.videos = (videolist?.videos)!
                    } else {
                        self.videos = []
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

//    MARK: button actions
    
    func selectedUS() {
        btnUS.setTitleColor(RED_FF5722, forState: .Normal)
        btnVN.setTitleColor(BLACK_727272, forState: .Normal)
        btnKOR.setTitleColor(BLACK_727272, forState: .Normal)
        getJSONData("https://itunes.apple.com/us/rss/topmusicvideos/limit=100/json")
        
    }
    
    func selectedVN() {
        btnUS.setTitleColor(BLACK_727272, forState: .Normal)
        btnVN.setTitleColor(RED_FF5722, forState: .Normal)
        btnKOR.setTitleColor(BLACK_727272, forState: .Normal)
        getJSONData("https://itunes.apple.com/vn/rss/topmusicvideos/limit=100/json")
        
    }
    
    func selectedKOR() {
        btnUS.setTitleColor(BLACK_727272, forState: .Normal)
        btnVN.setTitleColor(BLACK_727272, forState: .Normal)
        btnKOR.setTitleColor(RED_FF5722, forState: .Normal)
        getJSONData("https://itunes.apple.com/kr/rss/topmusicvideos/limit=100/json")
        
    }
    
    func moveToSearchVC(sender: UIButton) {
        let searchVC = SearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
//    MARK: support methods
    
    func convertTimeText(secondDuration: String) -> String {
        var ti: Double?
        ti = Double(secondDuration)
        let seconds = (ti! % 3600) % 60
        let minutes = (ti! % 3600) / 60
        let hours = (ti! / 3600)
        if (hours == 0) {
            return String(format: "%@:%@", toString(Int(minutes)), toString(Int(seconds)))
        } else {
            return String(format: "%@:%@:%@", toString(Int(hours)), toString(Int(minutes)), toString(Int(seconds)))
        }
    }
    
    func toString(number: Int) -> String {
        if(number > 10) {
            return String(number)
        } else {
            return "0" + String(number)
        }
    }
    
//    MARK: VideoCellDelegate method
    
    func tapToAddFavorite(cell: CustomCollectionViewCell, key: Int) {
        
        let index = self.collectionView.indexPathForCell(cell)?.row
        let video = self.videos[index!]
        
        if (video.isFavorite == true) {
            CommonUIFunc.simpleAlert(FAVOR_TITLE, message: ITEM_SAVED, viewController: self)
        } else {        
            CommonDataFunc.saveFavoriteData(video.vid_name!, artist: video.artist!, imageLink: video.cover_imgs[2].linkAvatar!, wvLink: video.wvlink!, key: key)
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
