//
//  CustomCollectionViewCell.swift
//  Test
//
//  Created by Le Thi An on 12/3/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit

protocol VideoCellDelegate {
    var key: Int {get set}
    func tapToAddFavorite (cell : CustomCollectionViewCell, key: Int)
}

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnAddCollection: UIButton!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var videoDel : VideoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func saveFavoriteObject(sender: UIButton) {
        self.btnAddCollection.setImage(UIImage(named: "ic_addedcollection"), forState: .Normal)
        videoDel?.tapToAddFavorite(self, key: (videoDel?.key)!)
    }

}
