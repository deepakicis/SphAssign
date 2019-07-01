//
//  DataDetail.swift
//  SphAssignment
//
//  Created by Deepak Kumar on 01/7/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class DataDetail : Object {
    
    @objc dynamic var year : Int = 0
    @objc dynamic var dataVolume : Float = 0.0
    @objc dynamic var isDecreaseVolumeData : Bool = false
    
    var records = List<Record>()
    
    override static func primaryKey() -> String? {
        return "year"
    }
    
    convenience init(record: Record) {
        self.init()
        self.dataVolume = record.data_Used
        self.isDecreaseVolumeData = false
        self.records.append(record)
    }
    
    func addRecord(record: Record) {
        if let realm = try? Realm() {
            try? realm.write {
                self.records.append(record)
                self.decreaseDataCheck()
            }
        }
    }
    
    func decreaseDataCheck() {
        let sortedRecords = self.records.sorted(by: { $0.pos < $1.pos })
        var data : Float = 0.0
        
        for (index, record) in sortedRecords.enumerated() {
            data += record.data_Used
            if index != 0 {
                if record.data_Used - self.records[index - 1].data_Used < 0 {
                    self.isDecreaseVolumeData = true
                }
            }
        }
        self.dataVolume = data
    }
    
}
