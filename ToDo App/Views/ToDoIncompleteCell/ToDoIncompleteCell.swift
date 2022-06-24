//
//  ToDoIncompleteCell.swift
//  ToDo App
//
//  Created by Ajaya Mati on 23/06/22.
//

import UIKit

class ToDoIncompleteCell: UITableViewCell {
    
    @IBOutlet weak var checkbox: CheckBox!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkbox.isChecked = false
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
