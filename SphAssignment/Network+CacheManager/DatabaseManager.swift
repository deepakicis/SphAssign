//
//  DatabaseManager.swift
//  SphAssignment
//
//  Created by Deepak Kumar on 01/7/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager: NSObject {
    
    class func addData(dataProvided: DataDetail) {
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(dataProvided)
            }
        }
    }

    class func updateData(dataProvided: DataDetail) {
        if let realm = try? Realm() {
            let dataDB = realm.objects(DataDetail.self).filter{ $0.year == dataProvided.year }.first
            try? realm.write {
                dataDB?.dataVolume = dataProvided.dataVolume
                dataDB?.records = dataProvided.records
            }
        }
    }
    
    
    
    
}
