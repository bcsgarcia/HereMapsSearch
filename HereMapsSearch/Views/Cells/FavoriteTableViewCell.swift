//
//  FavoriteTableViewCell.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 30/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ivLocation: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    
    var favorite: Favorite! {
        didSet {
            self.lblLocation.text = self.favorite.label
            if let imageData = self.favorite.image {
                ivLocation.image = UIImage(data: imageData)
            }
        }
    }
    
    func prepare(with favorite: Favorite) {
        self.favorite = favorite
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
