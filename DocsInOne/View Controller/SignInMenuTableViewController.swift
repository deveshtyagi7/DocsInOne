//
//  SignInMenuTableViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 13/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
class SignInMenuTableViewController: UITableViewController {
    var didTapMenuType: ((menuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = menuType(rawValue: indexPath.row) else { return }
        if(indexPath.row == 0){
            dismiss(animated: true)
        } else{
            dismiss(animated: true) { [weak self] in
                print("Dismissing: \(menuType)")
                self?.didTapMenuType?(menuType)
            }
        }
    }
    
    
    
    
    
}
enum menuType : Int{
    case home
    case sendDoc
    case receivedDoc
    case editprofile
    case faqs
    case about
    case contactUs
    case logout
    
    
}
