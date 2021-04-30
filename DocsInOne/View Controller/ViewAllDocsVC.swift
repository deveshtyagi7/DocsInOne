//
//  ViewAllDocsVC.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 30/04/21.
//  Copyright © 2021 deveshtyagi7. All rights reserved.
//

import UIKit

class ViewAllDocsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var listOfDocs :[Docs]? {
        didSet{
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        // Do any additional setup after loading the view.
        tableView.register(DocPreviewTableViewCell.nib, forCellReuseIdentifier: DocPreviewTableViewCell.identifier)
    }
    

    
}
extension ViewAllDocsVC : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfDocs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocPreviewTableViewCell.identifier) as? DocPreviewTableViewCell else { return UITableViewCell()
            
        }
        cell.doc = listOfDocs?[indexPath.row]
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
}
extension ViewAllDocsVC : DocPreviewTableViewCellDelegate{
    func shareDocument(docPath: URL) {
      
           
        let objectsToShare = [docPath] as [Any]
        // let shareItems = [ qrCodeImageView.image] as [Any]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: objectsToShare , applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}
