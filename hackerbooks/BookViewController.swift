//
//  ViewController.swift
//  hackerbooks
//
//  Created by fran on 5/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import UIKit

class BookViewController: UIViewController,UISplitViewControllerDelegate {

    var model : Book?
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    init(model book:Book?){
       
        model = book
        
        super.init(nibName: nil, bundle: nil)
        
        print(book)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.layer.cornerRadius = bookImageView.frame.width/4
        bookImageView.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        edgesForExtendedLayout = .None
        updateViews()
    }
    
    
    func updateViews(){
        
        bookImageView.image = UIImage(data: NSData(contentsOfURL: (model?.imageURL)!)!)
        title = self.model?.title
        authorsLabel.text = "Authors: " + (model?.authors.joinWithSeparator(", "))!
        tagsLabel.text = "Tags: " + (model?.tags.joinWithSeparator(", "))!
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        
        if(model?.isFavorite == true){
            favImage.image = UIImage(named: "star_PNG1592")
            favButton.setTitle("Desmarcar como favorito", forState: .Normal)

        }else{
            favImage.image = nil
            favButton.setTitle("Marcar como favorito", forState: .Normal)

        }
    
    }
    
    @IBAction func didClickFav(sender: UIButton) {
        
        if model?.isFavorite == true{
            model?.isFavorite = false
            favImage.image = nil
            favButton.setTitle("Marcar como favorito", forState: .Normal)
            
        }else{
            model?.isFavorite = true
            favImage.image = UIImage(named: "star_PNG1592")
            favButton.setTitle("Desmarcar como favorito", forState: .Normal)
        }
        
    }
    @IBAction func openPDFViewer(sender: AnyObject) {
        
        let PDFViewer = PDFViewController(url: (model?.pdfURL)!)
        
        navigationController?.pushViewController(PDFViewer, animated: true)
        
        
    }
    
    func splitViewController(svc: UISplitViewController, willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
        if displayMode == .PrimaryHidden{
            navigationItem.leftBarButtonItem = svc.displayModeButtonItem()
        }
    }
}


extension BookViewController:LibraryTableViewControllerDelegate{
    
    func libraryTableViewController(vc: LibraryTableViewController, book: Book) {
        model = book
        updateViews()
        
    }
    
}
