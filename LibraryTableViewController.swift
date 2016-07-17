//
//  LibraryTableViewController.swift
//  hackerbooks
//
//  Created by fran on 7/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {
    
    var model : Library
    var delegate:LibraryTableViewControllerDelegate?

    
    //MARK: Initializers
    
    init(library : Library){
        
        self.model = library
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "BookTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "bookCell")
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(updateUserDefaults), name: UserDidFav, object: nil)
        
        self.title = model.title

    }
    
    //MARK:Favorites
    
    func updateUserDefaults(notification : NSNotification){
        
        let newBook = notification.userInfo!["book"] as! Book
        
        for var b in model.books!{
            if b == newBook{
                b = newBook
            }
        }
        var favs = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as! [String]
        
        if newBook.isFavorite == true{
            model.tags["favorites"]?.append(newBook)
            favs.append(newBook.title)
            NSUserDefaults.standardUserDefaults().setValue(favs, forKey: "favorites")
        }else{
            for (index,book) in (model.tags["favorites"]?.enumerate())!{
                if book == newBook{
                    model.tags["favorites"]?.removeAtIndex(index)
                }
            }
            
            for (index,title) in favs.enumerate(){
                if title == newBook.title{
                    favs.removeAtIndex(index)
                }
            }
            NSUserDefaults.standardUserDefaults().setValue(favs, forKey: "favorites")
        }
        
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return model.tags.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let section = model.tags[keyforSection(section)]{
            return section.count
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : BookTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("bookCell") as! BookTableViewCell
        
        let book : Book  = (model.booksForTag(keyforSection(indexPath.section))?[indexPath.row])!
        
        cell.titleLabel.text = book.title
        
        cell.authors.text = book.authors.joinWithSeparator(",")
        
        let imageURL = book.imageURL
        
        cell.coverImage.image = UIImage(data: NSData(contentsOfURL: imageURL)!)
        

        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont(name: "Helvetica", size: 14)!
        title.textColor = UIColor.whiteColor()
        title.text = self.tableView(tableView, titleForHeaderInSection: section)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
        header.contentView.backgroundColor = UIColor.blackColor()
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return keyforSection(section).uppercaseString
    }
    
    func keyforSection(index:Int) -> String{
        
        var section = model.tags.keys.sort()
        
        if let order = section.indexOf("favorites"){
            section.removeAtIndex(order);
            section.insert("favorites", atIndex:0)
            
        }
        
        
        return section[index]
    }
    //MARK: TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let book = model.booksForTag(keyforSection(indexPath.section))?[indexPath.row]
        book?.sendNotification()
        delegate?.libraryTableViewController(self, book: book!)
    }
}

protocol LibraryTableViewControllerDelegate{
    func libraryTableViewController(vc:LibraryTableViewController, book:Book)
}

extension LibraryTableViewController:LibraryTableViewControllerDelegate{
    
    func libraryTableViewController(vc: LibraryTableViewController, book: Book) {
        
        
        let vc = BookViewController(model: book)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
