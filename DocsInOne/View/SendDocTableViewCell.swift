//
//  SendDocTableViewCell.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 26/04/21.
//  Copyright © 2021 deveshtyagi7. All rights reserved.
//

import UIKit
//
class SendDocTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBoxImg: UIImageView!
    @IBOutlet weak var docNameLbl: UILabel!
    var ischeck : Bool = false
    let checkImage = UIImage(systemName: "checkmark.square")
    let uncheckImg = UIImage(systemName: "square")
    var doc : Docs?{
        didSet{
            ischeck = doc!.isSelected
            let img = ischeck ?  checkImage :  uncheckImg
             checkBoxImg.image = img
             
           
            docNameLbl.text = doc?.name
             
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
