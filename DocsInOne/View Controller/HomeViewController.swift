//
//  ViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 13/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIBarButtonItem!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addNavBarImage()
    }
  
    let transition  = SlideInTransition()
    var topView: UIView?
    
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
        
       
            guard let menuViewController = storyboard.instantiateViewController(identifier: "LoggedOutMenuTableViewController") as? LoggedOutMenuTableViewController else{return}
        
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
    
    func transitionToNew(_ menuType: logOutMenuType) {
                 let title = String(describing: menuType).capitalized
                 self.title = title

                 topView?.removeFromSuperview()
                 switch menuType {
//                 case .profile:
//                     let view = UIView()
//                     view.backgroundColor = .yellow
//                     view.frame = self.view.bounds
//                     self.view.addSubview(view)
//                     self.topView = view
//                 case .editprofile:
//                     let view = UIView()
//                     view.backgroundColor = .blue
//                     view.frame = self.view.bounds
//                     self.view.addSubview(view)
//                     self.topView = view
                 default:
                     break
                 }
             }
       
    
    
    
    
    @IBAction func SignInButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "SignInAndRegister", bundle: nil)
        
        guard let SignInAndRegisterViewController = storyboard.instantiateViewController(identifier: "SignInAndRegisterViewController") as? SignInAndRegisterViewController else {return}
        self.navigationController?.pushViewController( SignInAndRegisterViewController, animated: true)
    }
    
    @objc func onClickTransparentView(){
        dismiss(animated: true)
        
    }
    
    
    
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

