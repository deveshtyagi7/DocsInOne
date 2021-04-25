//
//  CategoryTableViewCell.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 24/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
protocol CategoryTableViewCellDelegate : class {
   func goToUploadDoc(docName :String)
}
class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    let govtDoc = ["Aadhar","Pan Card", "Driving Licence"]
    let personalDoc = [ "10th Marksheet","Insurance","12th Marksheet"]
    var isForGovt = false
    var delegate : CategoryTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension CategoryTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isForGovt{
            return govtDoc.count
        }else {
            return personalDoc.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        if isForGovt{
            cell.categoryCellImage.image = UIImage(named: govtDoc[indexPath.row])
            cell.categoryCellName.text = govtDoc[indexPath.row]
        }else {
            cell.categoryCellImage.image = UIImage(named: personalDoc[indexPath.row])
            cell.categoryCellName.text = personalDoc[indexPath.row]
        }
       return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isForGovt{
            delegate?.goToUploadDoc(docName: govtDoc[indexPath.row])
        }else{
            delegate?.goToUploadDoc(docName: personalDoc[indexPath.row])
        }
    }
    
    
}
extension CategoryTableViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
           return CGSize(width: 130, height: 160 )
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 8.0
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 2.0
       }
}
