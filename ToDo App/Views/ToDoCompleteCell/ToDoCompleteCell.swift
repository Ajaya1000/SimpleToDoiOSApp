//
//  ToDoCompleteCell.swift
//  ToDo App
//
//  Created by Ajaya Mati on 23/06/22.
//

import UIKit

class ToDoCompleteCell: UITableViewCell {
    
    @IBOutlet weak var buttonClick: CheckBox!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        buttonClick.addTarget(self, action: #selector(clickedCalled(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clickedCalled(_ sender: UIButton) {
        print(sender.tag)
    }
}
