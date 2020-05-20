//
//  MenuTableViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 13/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit

class LoggedOutMenuTableViewController: UITableViewController {

   var didTapMenuType: ((logOutMenuType) -> Void)?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let menuType = logOutMenuType(rawValue: indexPath.row) else { return }
         
                dismiss(animated: true) { [weak self] in
                    print("Dismissing: \(menuType)")
                    self?.didTapMenuType?(menuType)
             
            }
        }
        
        
        
        
        
    }
    enum logOutMenuType : Int{
        case signIn
        case signUp
        case help
        case faqs
        case about
        case contact

        
        
    }
