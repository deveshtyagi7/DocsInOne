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
    
    //MARK: Properties
    
    @IBOutlet weak var signInButton: UIBarButtonItem!
    let transition  = SlideInTransition()
    var topView: UIView?
    
    
    
    
    //MARK:- Auto Login
    fileprivate func autoLogin() {
        
        if Auth.auth().currentUser != nil{
            goToHomeLoggedInViewController()
        }
    }
    
    
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLogin()
        addNavBarImage()
        
        
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
        case .signIn :
            goToSignInAndRegisterViewController()
            break
        case .signUp :
            goToRegisterViewController()
            break
            
        default:
            break
        }
    }
    
    
    
    
    
    @IBAction func SignInButtonPressed(_ sender: Any) {
        
        goToSignInAndRegisterViewController()
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

//MARK: TableView Delegate
extension HomeViewController :UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageSliderTableViewCell", for: indexPath) as! ImageSliderTableViewCell
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableCell", for: indexPath) as! CategoryTableViewCell
            cell.categoryNameLabel.text = "Category \(row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == 0 {
            return 345
        }else{
            return 220
        }
        
    }
    
    
    
}
// MARK: ImageSliderTableViewCellDelegate and navigations
extension HomeViewController : ImageSliderTableViewCellDelegate{
    func goToSignInAndRegisterViewController() {
        
        let storyboard = UIStoryboard(name: "SignInAndRegister", bundle: nil)
        
        guard let SignInAndRegisterViewController = storyboard.instantiateViewController(identifier: "SignInAndRegisterViewController") as? SignInAndRegisterViewController else {return}
        self.navigationController?.pushViewController( SignInAndRegisterViewController, animated: true)
    }
    
    func goToRegisterViewController(){
        let storyboard = UIStoryboard(name: "SignInAndRegister", bundle: nil)
        guard let registerViewController = storyboard.instantiateViewController(identifier: "RegisterViewController") as? RegisterViewController else {return}
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    func goToHomeLoggedInViewController(){
        let storyboard = UIStoryboard(name: "HomeLoggedIn", bundle: nil)
        guard let homeLoggedInViewController = storyboard.instantiateViewController(identifier: "HomeLoggedInViewController") as? HomeLoggedInViewController else{return}
        self.navigationController?.pushViewController(homeLoggedInViewController, animated: false)
    }
}
