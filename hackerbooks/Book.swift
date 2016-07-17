//
//  Book.swift
//  hackerbooks
//
//  Created by Fran on 3/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import Foundation
import UIKit

class Book : Comparable{
    //MARK: Stored properties
    
    var title : String
    let authors : [String]
    let tags : [String]
    let imageURL : NSURL
    let pdfURL : NSURL
    var isFavorite : Bool{
        didSet{
            let nc = NSNotificationCenter.defaultCenter()
            
            let notification = NSNotification(name: UserDidFav, object: nil,userInfo: ["book":self])
            
            nc.postNotification(notification)
            
        }
    }
    
    let nc = NSNotificationCenter.defaultCenter()
    
    init(title : String,authors :[String],tags :[String],imageURL : NSURL,pdfURL : NSURL) {
   
        self.title = title
        self.authors = authors
        self.tags = tags
        self.imageURL = imageURL
        self.pdfURL = pdfURL
        self.isFavorite = false

    }
    
    func sendNotification(){
        
        let notification = NSNotification(name: BookDidChange, object: nil, userInfo: ["book": self])
        
        nc.postNotification(notification)
        
    }
    
        
    //MARK: - Proxies
    var proxyForComparison : String{
        get{
            return "\(title)\(authors)\(pdfURL)"
        }
    }
    
    var proxyForSorting : String{
        get{
            return proxyForComparison
        }
    }
}

//MARK: - Equatable & Comparable
func ==(lhs: Book, rhs: Book) -> Bool{
    
    guard (lhs !== rhs) else{
        return true
    }
    
    return lhs.proxyForComparison == rhs.proxyForComparison
}

func <(lhs: Book, rhs: Book) -> Bool{
    return lhs.proxyForSorting < rhs.proxyForSorting
}

extension Book :CustomStringConvertible{
    var description : String {
        get {
            return "<\(self.dynamicType)>\(title)"
        }
    }
}