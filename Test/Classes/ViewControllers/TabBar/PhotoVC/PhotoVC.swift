//
//  PhotoVC.swift
//  Test
//
//  Created by Le Thi An on 12/8/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class PhotoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FirstPhotoCellDelegate, SecondPhotoCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos:[PhotoObject] = []
    
    var fkey:Int = 3
    var skey:Int = 3
    
//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        self.tableView.registerNib(UINib(nibName: "SecondPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "SecondPhotoTableViewCell")
        self.tableView.backgroundColor =  UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        initView()
        getJSONData("https://api.500px.com/v1/photos?feature=popular&consumer_key=IBt4yJPYOqNHqEgb15Yr734A3ELdVu0Tl67yie7Y&page=0&image_size=3")
    }
    
    override func viewWillAppear(animated: Bool) {
        Async.main{
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//  MARK: UITableViewDataSource methods
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.photos.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let obj = self.photos[index]
        
        let detailsWV = DetailsWebView()
        detailsWV.title = obj.title
        detailsWV.wvLink = obj.photo
        self.navigationController?.pushViewController(detailsWV, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        
        
        
        if(indexPath.row % 2 == 0) {
            
            let identifier = "PhotoCell"
            
            var cell:PhotoTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? PhotoTableViewCell
            
            if cell == nil {
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? PhotoTableViewCell
                
            }

            let photo = self.photos[indexPath.row]
            
            cell.lblUsrFname.text = photo.fullname
//            print(photo.fullname)
            
            let date = dateFormatter.dateFromString(photo.dateCreated!)
            let dateCreated = "- " + Common.dateDiff(date!)
            
            
            let usrnameString: NSMutableAttributedString = NSMutableAttributedString(string: photo.username! + " ", attributes: [NSFontAttributeName:ProximaNovaSemibold14!])
            usrnameString.addAttribute(NSForegroundColorAttributeName, value: BLACK_212121, range: NSMakeRange(0, usrnameString.length))
            
            let dateString: NSMutableAttributedString = NSMutableAttributedString(string: dateCreated, attributes: [NSFontAttributeName:ProximaNovaRegular14!])
            dateString.addAttribute(NSForegroundColorAttributeName, value: GRAY_ABABAB, range: NSMakeRange(0, dateString.length))
            
            usrnameString.appendAttributedString(dateString);
            cell.lblUsrname.attributedText = usrnameString
            
            
            if (photo.title != nil) {
                cell.lblTile.text = photo.title
            } else {
                cell.lblTile.text = "No title"
            }
            
            if (photo.descriptions == nil) {
                cell.lblContent.text = "No description"
            } else {
            
                let max = Common.countMacChars(cell.lblContent)
                //        print(max)
            
                var myMutableString = NSMutableAttributedString()
                let textWithoutBrk = Common.removeBreakLine(photo.descriptions!)
                let txtDescription = Common.checkDescriptionLength(textWithoutBrk, max: max)
                let finalText = Common.removeChar(txtDescription, label: cell.lblContent)
                //            print("sau khi remove: " + finalText)
                //            print("=====================================================================")
                if (txtDescription.characters.count >= max) {
                    myMutableString = NSMutableAttributedString(string: finalText, attributes: [NSFontAttributeName:ProximaNovaRegular145!])
                    myMutableString.addAttribute(NSForegroundColorAttributeName, value: GREEN_4CAF50, range: NSRange(location:finalText.characters.count-9, length:9))
                    cell.lblContent.attributedText = myMutableString
                    cell.lblContent.userInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: "goToDetailsVC:")
                    cell.lblContent.addGestureRecognizer(tapGesture)
                } else {
                    cell.lblContent.text = txtDescription
                }
            }
            
            cell.lblLikeNum.text = convertNumberToString(photo.likeNum!) + " Likes"
            cell.lblViewNum.text = convertNumberToString(photo.viewNum!) + " Views"
            
            getImageData(photo.avatar_img!, imageView: cell.img_avatar)
            getImageData(photo.photo!, imageView: cell.photo)
            
            if CommonDataFunc.isFavorite(photo.fullname!, title: photo.title!, imageLink: photo.photo!, key: 3) == true {
                photo.isFavorite = true
            } else {
                photo.isFavorite = false
            }
            
            if (photo.isFavorite == true) {
                cell.btnFavorite.setImage(UIImage(named: "btnFavorite2"), forState: .Normal)
            } else {
                cell.btnFavorite.setImage(UIImage(named: "btnFavorite"), forState: .Normal)
            }

            
            cell.delegate = self
            cell.firstPhotoCellDel = self
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor
            cell.layer.borderWidth = 0.5
            
            return cell
            
        } else {
            let identifier = "SecondPhotoTableViewCell"
            
            var cell:SecondPhotoTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? SecondPhotoTableViewCell
            
            if cell == nil {
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? SecondPhotoTableViewCell
                
            }
            
            let photo = self.photos[indexPath.row]
            
            cell.lblUsrFname.text = photo.fullname
            
            let date = dateFormatter.dateFromString(photo.dateCreated!)
            let dateCreated = "- " + Common.dateDiff(date!)
            
            let usrnameString: NSMutableAttributedString = NSMutableAttributedString(string: photo.username! + " ", attributes: [NSFontAttributeName:ProximaNovaSemibold14!])
            usrnameString.addAttribute(NSForegroundColorAttributeName, value: BLACK_212121, range: NSMakeRange(0, usrnameString.length))
            
            let dateString: NSMutableAttributedString = NSMutableAttributedString(string: dateCreated, attributes: [NSFontAttributeName:ProximaNovaRegular14!])
            dateString.addAttribute(NSForegroundColorAttributeName, value: GRAY_ABABAB, range: NSMakeRange(0, dateString.length))
            
            usrnameString.appendAttributedString(dateString);
            cell.lblUsrname.attributedText = usrnameString
            
            if (photo.title != nil) {
                cell.lblTile.text = photo.title
            } else {
                cell.lblTile.text = "No title"
            }
            
            
            
            if (photo.descriptions == nil) {
                cell.lblContent.text = "No description"
            } else if (Common.isTextOutOfBound(cell.lblContent, str: photo.descriptions!)) {
                cell.lblContent.text = photo.description
                cell.lblContent.userInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: "goToDetailsVC:")
                cell.lblContent.addGestureRecognizer(tapGesture)
            }
            
            //        print(countMacChars(cell.lblContent))
            
            cell.lblLikeNum.text = convertNumberToString(photo.likeNum!) + " Likes"
            cell.lblViewNum.text = convertNumberToString(photo.viewNum!) + " Views"
            
            getImageData(photo.avatar_img!, imageView: cell.img_avatar)
            getImageData(photo.photo!, imageView: cell.photo)
            
            if CommonDataFunc.isFavorite(photo.fullname!, title: photo.title!, imageLink: photo.photo!, key: 3) == true {
                photo.isFavorite = true
            } else {
                photo.isFavorite = false
            }
            
            if (photo.isFavorite == true) {
                cell.btnFavorite.setImage(UIImage(named: "btnFavorite2"), forState: .Normal)
            } else {
                cell.btnFavorite.setImage(UIImage(named: "btnFavorite"), forState: .Normal)
            }
            
            cell.delegate = self
            cell.secondPhotoCellDel = self
            cell.layer.masksToBounds = true
            cell.layer.borderColor = GRAY_E1E1E1.CGColor
            cell.layer.borderWidth = 0.5
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row % 2 == 0) {
            return 501
        } else {
            return 470
        }
        
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
        
    }
    
    
//  call api from server
    
    func getJSONData(urlAsString:String){
        
        Async.main{
            CommonUIFunc.showActivityIndicator(self)
        }
        
        Alamofire.request(.GET, urlAsString, parameters: nil, headers: nil).responseJSON { (response) -> Void in
            
            if response.result.isSuccess {
                
                Async.background{
                    
                    let photolist = Mapper<PhotoList>().map(response.result.value!)
                    if photolist!.photos != nil {
                        self.photos = (photolist!.photos)!
                    } else {
                        self.photos = []
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
    
//  MARK: Support functions    
    
    func convertNumberToString(number: Double) -> String {
        if (number < 1000) {
            return String(format: "%.0f", number)
        } else {
            return String(format: "%.1fk", number/1000)
        }
    }   
    
//    MARK: Use Haneke Library to download and set cache for images
    
    func getImageData(urlImage: String, imageView: UIImageView) {
        imageView.hnk_setImageFromURL(NSURL(string:urlImage)!, placeholder: nil, format: nil, failure: { (error) -> () in
            
            }) { (image) -> () in
                imageView.image = image
        }
        
    }
    
    
//   MARK: FirstPhotoCellDelegate method
    
    func tapToAddFavorite(cell: PhotoTableViewCell, fkey: Int) {
        
        let index = self.tableView.indexPathForCell(cell)?.row
        let photo = self.photos[index!]
        if (photo.isFavorite == true) {
            CommonUIFunc.simpleAlert(FAVOR_TITLE, message: ITEM_SAVED, viewController: self)
        } else {
            CommonDataFunc.saveFavoriteData(photo.title!, artist: photo.fullname!, imageLink: photo.photo!, wvLink: photo.photo!, key: fkey)
        }
    }

//    MARK: SecondPhotoCellDelegate method
    
    func tapToAddFavorite(cell: SecondPhotoTableViewCell, skey: Int) {
        let index = self.tableView.indexPathForCell(cell)?.row
        let photo = self.photos[index!]
        if (photo.isFavorite == true) {
            CommonUIFunc.simpleAlert(FAVOR_TITLE, message: ITEM_SAVED,viewController: self)
        } else {
            CommonDataFunc.saveFavoriteData(photo.title!, artist: photo.fullname!, imageLink: photo.photo!, wvLink: photo.photo!, key: skey)
        }
    }
    
//    MARK: button actions
    
    func moveToSearchVC(sender: UIButton) {
        let searchVC = SearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func goToDetailsVC(sender:UITapGestureRecognizer) {
        //        let index = indexPath.row
        //        let obj = self.photos[index]
        
        let detailsWV = DetailsWebView()
        //        detailsWV.title = obj.valueForKey("title") as? String
        self.navigationController?.pushViewController(detailsWV, animated: true)
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
