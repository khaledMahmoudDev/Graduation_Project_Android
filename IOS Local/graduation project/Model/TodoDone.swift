//
//  TodoDone.swift
//  graduation project
//
//  Created by farah on 7/9/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import Foundation
class TodoDone{
    var title : String
    var firebaseKey : String
    var date : String
    var time : String
    var category : String
    var priority : String
    
    init (titletxt : String, keytxt : String, dateTxt : String, timeTxt : String, categoryTxt : String, prioritytxt : String) {
        title = titletxt
        firebaseKey = keytxt
        date = dateTxt
        time = timeTxt
        category = categoryTxt
        priority = prioritytxt
    }
}
