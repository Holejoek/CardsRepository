//
//  ShapeCell.swift
//  Cards
//
//  Created by Иван Тиминский on 04.11.2021.
//

import UIKit

class ShapeCell: UITableViewCell {

    @IBOutlet weak var shapeName: UILabel!
    @IBOutlet weak var shapeView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
