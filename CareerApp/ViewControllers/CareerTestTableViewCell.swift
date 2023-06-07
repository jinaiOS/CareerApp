//
//  CareerTestTableViewCell.swift
//  CareerApp
//
//  Created by 김지은 on 2023/05/16.
//

import UIKit

class CareerTestTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAnswer1: UILabel!
    @IBOutlet var lblAnswer2: UILabel!
    @IBOutlet var lblAnswer3: UILabel!
    @IBOutlet var lblAnswer4: UILabel!
    @IBOutlet var lblAnswer5: UILabel!
    @IBOutlet var lblAnswer6: UILabel!
    @IBOutlet var lblAnswer7: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
