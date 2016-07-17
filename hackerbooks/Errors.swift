//
//  Errors.swift
//  hackerbooks
//
//  Created by Fran on 3/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import Foundation


enum BookError : ErrorType {
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case JSONParsingError
    case wrongJSONFormat
    case nilBook
}