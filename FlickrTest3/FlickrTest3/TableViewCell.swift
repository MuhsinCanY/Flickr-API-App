//
//  TableViewCell.swift
//  FlickrTest3
//
//  Created by Muhsin Can Yılmaz on 31.10.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
