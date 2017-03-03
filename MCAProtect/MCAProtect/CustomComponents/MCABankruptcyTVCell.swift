//
//  MCABankruptcyTVCell.swift
//  MCAProtect
//
//  Created by Accion Labs on 01/03/17.
//  Copyright © 2017 Accionlabs. All rights reserved.
//

import UIKit

class MCABankruptcyTVCell: UITableViewCell {
    @IBOutlet weak var liensView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        liensView.backgroundColor = UIColor.init(patternImage: UIImage(named : "liensBg")!)
        // Configure the view for the selected state
    }
    
}
