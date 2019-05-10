//
//  DarkSkyError.swift
//  Stormy
//
//  Created by Lou Batier on 11/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation


enum DarkSkyError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidUrl  
}
