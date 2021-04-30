//
//  DocPreviewTableViewCell.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 30/04/21.
//  Copyright © 2021 deveshtyagi7. All rights reserved.
//

import UIKit
import PDFKit
protocol DocPreviewTableViewCellDelegate : AnyObject {
    func shareDocument(docPath : URL)
}
class DocPreviewTableViewCell: UITableViewCell {
    var docUrl : URL?
    var delegate : DocPreviewTableViewCellDelegate?
    var doc :Docs?{
        didSet{
            docNameLbl.text = doc!.name
            FileDownloader.downlaoadFile(url: doc!.docUrl) { (path, err) in
                if err != nil{
                  //  ProgressHUD.showError()
                }
                if path != nil {
                    let urlPath : URL = URL(fileURLWithPath: path!)
                    if let document = PDFDocument(url: urlPath) {
                        self.docUrl = urlPath
                        DispatchQueue.main.async {
                         //   ProgressHUD.dismiss()
                            self.pdfViewer.document = document
                        }
                       
                    }
                }
            }
        }
    }
    @IBOutlet weak var docNameLbl: UILabel!
    @IBOutlet weak var pdfViewer: PDFView!{
        didSet{
            pdfViewer.autoScales = true
            pdfViewer.displayMode = .singlePage
          
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func shareBtnPressed(_ sender: Any) {
        delegate?.shareDocument(docPath: docUrl!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
