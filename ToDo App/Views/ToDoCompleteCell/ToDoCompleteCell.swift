//
//  ToDoCompleteCell.swift
//  ToDo App
//
//  Created by Ajaya Mati on 23/06/22.
//

import UIKit
import CoreData

class ToDoCompleteCell: UITableViewCell {
    

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var checkbox: CheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
