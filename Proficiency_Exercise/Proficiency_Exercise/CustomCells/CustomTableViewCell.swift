//
//  CustomTableViewCell.swift
//  Proficiency_Exercise
//
//  Created by sivaprasad reddy on 21/08/19.
//  Copyright © 2019 Siva. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData (dataObj: DataModel) {
        if dataObj.imageHref != nil && dataObj.imageHref != "" {
            self.imgView.sd_setImage(with: URL(string: dataObj.imageHref!), placeholderImage: UIImage(named: "image_placeholder.png"))
        }
        
        self.titleLabel.text = dataObj.title
        self.descriptionLabel.text = dataObj.description
        
    }

}
