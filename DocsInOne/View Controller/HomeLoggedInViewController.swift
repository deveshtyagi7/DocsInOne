//
//  HomeLoggedInViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 21/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseDatabase
class HomeLoggedInViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIImageView!
    
    @IBOutlet weak var uidTextField: UILabel!
    
    @IBOutlet weak var nameTextField: UILabel!
    let transition  = SlideInTransition()
    var topView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Shadow.applyShadowOnView(yourView: cardView, radius: 10)
        
        // Do any additional setup after loading the view.
        setupUserDetails()
    }
    func setupUserDetails(){
        if let userId = getUserID() {
            uidTextField.text = userId
            
            
            let userid = "+91\(userId)"
            let ref =  Database.database().reference()
            DispatchQueue.main.async {
                ref.child("phnNum").child(userid).child("Name").observeSingleEvent(of: .value) { (snapshot) in
                   print("\(snapshot)")
                    if let name = snapshot.value as? String {
                        print("NAme ===> \(snapshot.value)")
                        self.nameTextField.text = name
                    }
                }
                
            }
            
            
        }
    }
    
    func addNavBarImage(){
        let navController = navigationController!
        
        let image = UIImage(named: "TitleIcon")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView?.backgroundColor = .clear
        
        navigationItem.titleView = imageView
    }
    
    @IBAction func tabmeuButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        
        guard let menuViewController = storyboard.instantiateViewController(identifier: "SignInMenuTableViewController") as? SignInMenuTableViewController else{return}
        
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        swipeLeftGesture.direction = .left
        
        
        transition.dimmingView.addGestureRecognizer(tapGesture)
        transition.dimmingView.addGestureRecognizer(swipeLeftGesture)
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
        
    }
    @objc func onClickTransparentView(){
        dismiss(animated: true)
        
    }
    func transitionToNew(_ menuType: menuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .logout:
            AuthServices.logout(completion: {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                guard let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else {return}
                self.navigationController?.pushViewController(homeViewController, animated: true)
            }) { (err) in
                ProgressHUD.showError(err)
            }
            
            
       
        default:
            break
        }
    }
    
    func goToUploadDocVc(with docName : String){
        let storyboard = UIStoryboard(name: "UploadDocVc", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "UploadDocVc") as? UploadDocVc else {return}
        vc.docName = docName
        self.navigationController?.pushViewController( vc, animated: true)
    }
    
}
extension HomeLoggedInViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
extension HomeLoggedInViewController :UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableCell", for: indexPath) as! CategoryTableViewCell
        cell.delegate = self
        if indexPath.row == 0 {
            cell.categoryNameLabel.text = "Govt. Document"
            cell.isForGovt = true
        }else {
            cell.isForGovt = false
            cell.categoryNameLabel.text = "Personal Document"
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 220
        
    }
    
    
    
}
extension HomeLoggedInViewController : CategoryTableViewCellDelegate{
    func goToUploadDoc(docName: String) {
        print("doc ==> \(docName)")
        goToUploadDocVc(with: docName)
        
    }
    
    
}
