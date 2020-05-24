//
//  HomeLoggedInViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 21/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeLoggedInViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIImageView!
    
    @IBOutlet weak var uidTextField: UILabel!
    
    @IBOutlet weak var nameTextField: UIImageView!
    let transition  = SlideInTransition()
    var topView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Shadow.applyShadowOnView(yourView: cardView, radius: 10)
        // Do any additional setup after loading the view.
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
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                   print("Successfully log out")
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                guard let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else {return}
                self.navigationController?.pushViewController(homeViewController, animated: true)
             
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
                return
            }
            
            
            
            //              case .editprofile:
            //                  let view = UIView()
            //                  view.backgroundColor = .blue
            //                  view.frame = self.view.bounds
            //                  self.view.addSubview(view)
        //                  self.topView = view
        default:
            break
        }
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
