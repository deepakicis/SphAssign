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
    
    class func getData(year: Int? = nil) -> List<DataDetail> {
        var dataProvided = List<DataDetail>()
        if let realm = try? Realm() {
            if year != nil {
                let results = realm.objects(DataDetail.self).filter {$0.year == year}
                dataProvided = results.reduce(List<DataDetail>()) { (list, element) -> List<DataDetail> in
                    list.append(element)
                    return list
                }
            } else {
                let results = realm.objects(DataDetail.self)
                dataProvided = results.reduce(List<DataDetail>()) { (list, element) -> List<DataDetail> in
                    list.append(element)
                    return list
                }
            }
        }
        return dataProvided
    }

    class func clearData() {
        if let realm = try? Realm() {
            try? realm.write {
                realm.deleteAll()
            }
        }
    }
}
