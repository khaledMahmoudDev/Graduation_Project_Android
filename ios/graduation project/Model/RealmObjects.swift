//
//  RealmObjects.swift
//  graduation project
//
//  Created by ahmed on 5/2/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import Foundation
import RealmSwift

class NoteRealmObjects : Object{
    @objc dynamic var UserIdRealm : String? = nil
    @objc dynamic var noteNameRealm : String? = nil
    @objc dynamic var noteKeyRealm : String? = nil
    //var number = RealmOptional<Int>
    
    override static func primaryKey() -> String?{
        return "noteKeyRealm"
    }
    
}
extension NoteRealmObjects{
    func writeToRealm(){
        try! noteRealmFile.write {
            noteRealmFile.add(self, update: true)
        }
    }
}
