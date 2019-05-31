//
//  HistoryTableViewCell.swift
//  GeolocationCalculator
//
//  Created by Nathan C. Wichman on 5/31/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var destPoint: UILabel!
    @IBOutlet weak var origPoint: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
