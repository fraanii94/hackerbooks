//
//  PDFViewController.swift
//  hackerbooks
//
//  Created by fran on 6/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {

    var url: NSURL?
    
    let nc = NSNotificationCenter.defaultCenter()
    
    @IBOutlet weak var webView: UIWebView!
    
    init(url: NSURL){
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = false;
        loadPDF()
        nc.addObserver(self, selector: #selector(modelDidChange), name: BookDidChange, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        nc.removeObserver(self)
    }
    
    func modelDidChange(notification: NSNotification){
        
        let book : Book = notification.userInfo!["book"] as! Book
        url = book.pdfURL
        loadPDF()
    }
    
    func loadPDF(){
        webView.loadData(NSData(contentsOfURL: url!)!, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL())
    }
    
    
    
}
