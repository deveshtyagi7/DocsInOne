//
//  HomeTableViewCell.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 23/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit

protocol ImageSliderTableViewCellDelegate {
    func goToSignInAndRegisterViewController()
   
}
class ImageSliderTableViewCell: UITableViewCell {
    @IBOutlet weak var imagesSliderCollectionView: UICollectionView!
    @IBOutlet weak var imagePageController: UIPageControl!
    @IBOutlet weak var getStartedButton: UIButton!
    
    var timer = Timer()
    var currentPage = 0
    var delegate : ImageSliderTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        imagesSliderCollectionView.delegate = self
        imagesSliderCollectionView.dataSource = self
        Shadow.applyShadowOnView(yourView: getStartedButton, radius: 22.5)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval:2.0, target: self, selector: #selector(self.autoScrollImages), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func autoScrollImages(){
        
        if currentPage < 4{
            let index = IndexPath(item: currentPage, section: 0)
            imagesSliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            //imagePageController.currentPage = currentPage
            currentPage += 1
        }else{
            currentPage = 0
            let index = IndexPath(item: currentPage, section: 0)
            imagesSliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            //  imagePageController.currentPage = currentPage
            currentPage += 1
        }
    }
    @IBAction func getStartedPressed(_ sender: Any) {
        delegate?.goToSignInAndRegisterViewController()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension ImageSliderTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesSliderCollectionView.dequeueReusableCell(withReuseIdentifier: "imageSlider", for: indexPath) as! ImageCollectionViewCell
        let image = UIImage(named: "Pi\(indexPath.row)")
        cell.image = image
        return cell
    }
    
    
}
extension ImageSliderTableViewCell : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = imagesSliderCollectionView.frame.size
        print(size.width)
        print(size.height)
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
