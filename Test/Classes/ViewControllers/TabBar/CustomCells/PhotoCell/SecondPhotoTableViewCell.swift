//
//  SecondPhotoTableViewCell.swift
//  Test
//
//  Created by Le Thi An on 12/10/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit
import Social

protocol SecondPhotoCellDelegate {
    var skey: Int {get set}
    func tapToAddFavorite (cell : SecondPhotoTableViewCell, skey: Int)
}

class SecondPhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_avatar: UIImageView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblUsrFname: UILabel!
    @IBOutlet weak var lblTile: UILabel!
    @IBOutlet weak var lblViewNum: UILabel!
    @IBOutlet weak var lblLikeNum: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var lblUsrname: UILabel!
    @IBOutlet weak var photoView: UIView!

    var delegate: UIViewController?
    var secondPhotoCellDel: SecondPhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img_avatar.layer.masksToBounds = true
        img_avatar.layer.cornerRadius = img_avatar.frame.size.height/2
        
        self.buttonsView.layer.borderWidth = 0.5
        self.buttonsView.layer.borderColor = GRAY_E1E1E1.CGColor
        
        let shadowPath =  UIBezierPath(rect: photoView.bounds)
        self.lblTile.sizeToFit()
        photoView.clipsToBounds = false
        photoView.layer.shadowColor = UIColor.blackColor().CGColor
        photoView.layer.shadowOffset = CGSizeMake(0,1);
        photoView.layer.shadowOpacity = 0.15;
        photoView.layer.shadowPath = shadowPath.CGPath
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func savePhoto(sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(self.photo.image!, self, "saveImageToLibrary:didFinishSavingWithError:contextInfo:", nil)
    }
    
    @IBAction func sharePhoto(sender: UIButton) {
        let imageData = NSData(data: UIImageJPEGRepresentation(photo.image!,0)!)
        let imgSize = imageData.length
        print("image size: \(imgSize)")
//        if (imgSize > 12288) {
//            let warmingAlert = UIAlertController(title: INFO_TITLE, message: PHOTO_SIZE_LIMIT, preferredStyle: UIAlertControllerStyle.Alert)
//            
//            warmingAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            delegate?.presentViewController(warmingAlert, animated: true, completion: nil)
//        } else {
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbShare.addImage(photo.image)
                delegate?.presentViewController(fbShare, animated: true, completion: nil)
                
            } else {
//                let alert = UIAlertController(title: INFO_TITLE, message: LOGIN_FB_REQ, preferredStyle: UIAlertControllerStyle.Alert)
//                
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                delegate?.presentViewController(alert, animated: true, completion: nil)
                
                CommonUIFunc.simpleAlert(INFO_TITLE, message: LOGIN_FB_REQ, viewController: delegate!)
                
            }
//        }
        
    }
    
    func saveImageToLibrary(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
//            let ac = UIAlertController(title: INFO_TITLE, message: IMG_SAVED_SUCCESS, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            delegate?.presentViewController(ac, animated: true, completion: nil)
            
            CommonUIFunc.simpleAlert(INFO_TITLE, message: IMG_SAVED_SUCCESS, viewController: delegate!)
            
        } else {
//            let ac = UIAlertController(title: ERROR_TITLE, message: error?.localizedDescription, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            delegate?.presentViewController(ac, animated: true, completion: nil)
            
            CommonUIFunc.simpleAlert(ERROR_TITLE, message: (error?.localizedDescription)!, viewController: delegate!)
            
        }
    }
    @IBAction func saveFavoriteData(sender: AnyObject) {
        self.btnFavorite.setImage(UIImage(named: "btnFavorite2"), forState: .Normal)
        secondPhotoCellDel?.tapToAddFavorite(self, skey: (secondPhotoCellDel?.skey)!)
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.height -= 9
            super.frame = frame
        }
    }
    
}
