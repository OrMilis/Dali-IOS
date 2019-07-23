//
//  GenericTableViewCell.swift
//  Dali-ios
//
//  Created by Or Milis on 23/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit

class GenericTableViewCell: UITableViewCell {
    
    public static let identifier: String = "GenericTableViewCell"
    
    @IBOutlet weak var MainText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var SubText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
