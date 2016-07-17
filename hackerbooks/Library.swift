//
//  Library.swift
//  hackerbooks
//
//  Created by Fran on 3/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import Foundation

class Library{
    
    var title : String
    var books: [Book]?
    var tags: [String : [Book]] = [String : [Book]]()
    var booksCount: Int{
        get{
            let count : Int = self.books == nil ? 0 : self.books!.count
            return count
        }
    }
    //MARK: Initializers
    init(title:String,books: [Book]) {
        
        
        self.title = title

        self.books = books
        
        for book in books{
            for tag in book.tags{
                if (tags[tag] != nil){
                    tags[tag]?.append(book)
                }else{
                    tags[tag] = [Book]()
                    tags[tag]?.append(book)
                }
                
            }
        }
        tags["favorites"] = [Book]()
        
    }
    
    convenience init(jsonArray dicts: JSONArray){
        var books = [Book]()
        for jsonDict in dicts{
            do{
                let book =  try decode(book: jsonDict)
                books.append(book)
               
            }catch{
                print("Error")
            }
        }
        books.sortInPlace({$0.title < $1.title})
        
        
        self.init(title: "HackerBooks",books:books)
    
    }
    //MARK: Utils
    func bookCountForTag (tag : String?) -> Int{
        
        var count = 0

        if self.books != nil {
            for book: Book in self.books! as [Book] {
                if let t = tag{
                    if book.tags.contains(t) {
                        count = count + 1
                    }
                }
                
            }

        }
        
        return count
    }
    
    func booksForTag(tag: String?) -> [Book]? {
        var books : [Book] = []
        if self.books != nil{
            for book: Book in self.books! as [Book] {
                
                if(tag == "favorites"){
                    if book.isFavorite{
                        books.append(book)
                    }
                }else if let t = tag {
                    if book.tags.contains(t) {
                        books.append(book)
                    }
                }
                
            }

        }
        return books
    }
    
    func bookAtIndex (index: Int) -> Book?{
        return self.books == nil ? nil : self.books![index]
    }
    
    func addFavorites(){
        
        if  let favs = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String]{
            for book in books!{
                for fav in favs{
                    if fav == book.title{
                        book.isFavorite = true
                        tags["favorites"]!.append(book)
                    }
                }
            }
        }else{
            NSUserDefaults.standardUserDefaults().setValue([String](), forKey: "favorites")
        }
    }
    
}


extension Library : CustomStringConvertible{
    var description : String{
        get{
            return "<\(self.dynamicType)>"
        }
    }
}