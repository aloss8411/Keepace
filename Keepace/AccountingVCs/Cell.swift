//
//  Cell.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/23.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var icons: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descipt: UILabel!
    @IBOutlet weak var BGViews: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
