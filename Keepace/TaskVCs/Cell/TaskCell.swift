//
//  TaskCell.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/10.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var BGViews: UIView!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var descipt: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    
}

