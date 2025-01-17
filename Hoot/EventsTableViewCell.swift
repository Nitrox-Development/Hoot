//
//  EventsTableViewCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class EventsTableViewCell: PFTableViewCell {

    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var eventDateLabel: UILabel!
    @IBOutlet var eventTimeStamp: UILabel!
    @IBOutlet var eventAttendingCount: UILabel!
    @IBOutlet var eventTimeToGo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
