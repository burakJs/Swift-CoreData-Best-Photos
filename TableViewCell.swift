//
//  TableViewCell.swift
//  PhotoList
//
//  Created by Burak İmdat on 3.09.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
