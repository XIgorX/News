//
//  NewsTableViewCell.swift
//  News
//
//  Created by Igor Danilchenko on 23.01.18.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
