//
//  CustomTableViewCell.swift
//  Test
//
//  Created by Le Thi An on 12/3/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit
import CoreData

protocol MusicCellDelegate {
    var key: Int {get set}
    func tapToFavorite (cell : CustomTableViewCell, key: Int)
}

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSinger: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var musicCellDelegate : MusicCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func saveData(sender: UIButton) {
        self.btnFavorite.setImage(UIImage(named: "img_cell_normal"), forState: .Normal)
        musicCellDelegate?.tapToFavorite(self, key: (musicCellDelegate?.key)!)
        
    }

}