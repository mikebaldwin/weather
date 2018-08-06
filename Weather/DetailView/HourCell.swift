//
//  DetailViewCell.swift
//  Weather
//
//  Created by Michael Baldwin on 8/5/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import UIKit

class HourCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
