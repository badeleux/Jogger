//
//  RecordTableViewCell.swift
//  Jogger
//
//  Created by Kamil Badyla on 03.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class RecordTableViewCell: MGSwipeTableCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
