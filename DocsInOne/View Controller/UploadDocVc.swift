//
//  UploadDocVc.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 08/03/21.
//  Copyright © 2021 deveshtyagi7. All rights reserved.
//

import UIKit
import WeScan
import ProgressHUD
import FirebaseStorage
import FirebaseDatabase
import WebKit
import PDFKit
class UploadDocVc : UIViewController,ImageScannerControllerDelegate {
 
    @IBOutlet weak var pdfViewer: PDFView!
    @IBOutlet weak var viewDocBtn: UIButton!
    var docName = ""
    var docURL : URL?
    
    fileprivate func checkIfFileAvailable() {
        if let phonNum = getUserID() {
            let ref = Database.database().reference().child("docs").child(phonNum)
            print("\(phonNum) ===> \(docName)")
            
            ref.child("\(docName)").observeSingleEvent(of: .value) {[self] (snap) in
                
               
                if !snap.exists(){
                    hideViewDocBtn()
                }else {
                    if let docUrl = snap.value as? String{
                        let url = URL(string: docUrl)
                        docURL = url!
                    }
                   
                    //Download 
                }
                
            } withCancel: {[self] (err) in
                hideViewDocBtn()
               
                
            }
            
            
        }
    }
    func hideViewDocBtn(){
        viewDocBtn.isHidden = true
        viewDocBtn.isEnabled  = false
        pdfViewer.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfFileAvailable()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfViewer.isHidden = true
    }
    
    @IBAction func viewAlreadyUploadedDoc(_ sender: Any) {
        
        ProgressHUD.show("Downloading")
        pdfViewer.isHidden = false
        FileDownloader.downlaoadFile(url: docURL!) { (path, err) in
            if err != nil{
                ProgressHUD.showError()
            }
            if path != nil {
                let urlPath : URL = URL(fileURLWithPath: path!)
                if let document = PDFDocument(url: urlPath) {
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        self.pdfViewer.document = document
                    }
                   
                }
            }
        }
      
    }
    @IBAction func scanADoc(_ sender: Any) {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
    }
    
    
    @IBAction func selectDocFromPhotos(_ sender: Any) {
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        results.croppedScan.generatePDFData { (result) in
            switch result{
            
            case .success(let pdf):
                ProgressHUD.show("Uploading")
               
                Api.Upload.uploadDocToDatabase(docName: self.docName, data: pdf ) { (data) in
                    ProgressHUD.showSucceed()
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(_):
                print(result)
            }
            
        }
        scanner.dismiss(animated: true)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
}
