//
//  CheckBox.swift
//  ToDo App
//
//  Created by Ajaya Mati on 23/06/22.
//

import UIKit

class CheckBox: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    let checkedImage  = UIImage(named: "CheckedCheckBox")! as UIImage
    let uncheckedImage = UIImage(named: "UncheckedCheckBox")! as UIImage

    //Bool property
    var isChecked:Bool = false{
        didSet{
            if isChecked == true {
                self.button.setImage(checkedImage, for: .normal)
            }
            else {
                self.button.setImage(uncheckedImage, for: .normal)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CheckBox", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
}
