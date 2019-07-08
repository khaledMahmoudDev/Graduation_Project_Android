//
//  CustomUsersEmail.swift
//  graduation project
//
//  Created by ahmed on 6/21/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import Foundation
import UIKit
class CustomUsersEmail{
    
    var usersEmail : String
    var userName : String
    var userImage : UIImage?
    
    init (usersEmailtxt : String, userNametxt : String, userImageImg : UIImage) {
        usersEmail = usersEmailtxt
        userName = userNametxt
        userImage = userImageImg
    }
}
