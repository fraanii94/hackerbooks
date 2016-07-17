//
//  JSONParse.swift
//  hackerbooks
//
//  Created by Fran on 3/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import Foundation

typealias JSONObject        = AnyObject
typealias JSONDictionary    = [String : JSONObject]
typealias JSONArray         = [JSONDictionary]


func decode(book json: JSONDictionary) throws -> Book{
    
    guard let pdfURL = json["pdf_url"] as? String, let pdf = NSURL(string: pdfURL) else {
        throw BookError.wrongURLFormatForJSONResource
    }
    
    guard let imgURL = json["image_url"] as? String, let img = NSURL(string: imgURL) else {
        throw BookError.wrongURLFormatForJSONResource
    }
    guard let title = json["title"] as? String else {
        throw BookError.JSONParsingError
    }
    guard let tags = json["tags"]?.componentsSeparatedByString(", ") else {
        throw BookError.JSONParsingError
    }
    guard let authors = json["authors"]?.componentsSeparatedByString(", ") else {
        throw BookError.JSONParsingError
    }
    
    
    print("t" + "\(title)")
    
    return Book(title: title, authors: authors, tags: tags, imageURL: img, pdfURL: pdf)
}


func decode(book json: JSONDictionary?) throws -> Book {
    // Comprobar caso opcional
    if case .Some(let book) = json {
        return try decode(book: book)
    }else {
        throw BookError.nilBook
    }
}

func downloadBooks() -> String?{
        
    let url = NSURL(string: "https://keepcodigtest.blob.core.windows.net/containerblobstest/books_readable.json")!
        
    guard let data = NSData(contentsOfURL: url),
        json = String(data: data, encoding: NSUTF8StringEncoding) else{
        return nil
    }
        
    do {
        try json.writeToURL(documentsPath(), atomically: false, encoding: NSUTF8StringEncoding)
    }
    catch {
        return nil
    }
    return json
}

func constructJSON() -> JSONArray?{
    let userDefaults = NSUserDefaults.standardUserDefaults()
    if !userDefaults.boolForKey("alreadyLoaded") {
        
        if let jsonData = readFromLocal()?.dataUsingEncoding(NSUTF8StringEncoding),
            maybeArray = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? JSONArray{
            
            return maybeArray
        }
        userDefaults.setBool(true, forKey: "alreadyLoaded")
        
    }else {
        if let jsonData = downloadBooks()?.dataUsingEncoding(NSUTF8StringEncoding),
            maybeArray = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? JSONArray{
            
            return maybeArray
        }
    }
    return JSONArray()
}

func readFromLocal() -> String? {
    
    var json : String = ""
    do {
        json = try String(contentsOfURL: documentsPath(), encoding: NSUTF8StringEncoding)
    }
    catch {
        return nil
    }
    return json
}

func documentsPath() -> NSURL{
    
    var path : NSURL = NSURL()
    if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
                                                     NSSearchPathDomainMask.AllDomainsMask, true).first {
        
        path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("books.json")
    }
    return path
}





