//
//  ViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 13/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
  
    
    
    let transition  = SlideInTransition()
    var topView: UIView?

    
    
    @IBAction func tabmeuButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)

                    
        guard let menuViewController = storyboard.instantiateViewController(identifier: "LoggedOutMenuTableViewController") as? LoggedOutMenuTableViewController else{return}
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        swipeLeftGesture.direction = .left
        
        
        transition.dimmingView.addGestureRecognizer(tapGesture)
        transition.dimmingView.addGestureRecognizer(swipeLeftGesture)
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
            
            
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

