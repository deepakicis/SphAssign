//
//  UsageDetailsTableCell.swift
//  SphAssignment
//
//  Created by Deepak Kumar on 01/7/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class Record : Object {
    
    @objc dynamic var r_Id : Int = 0
    @objc dynamic var data_Used : Float = 0.0
    @objc dynamic var pos : String = ""
    
    convenience init(json: [String : AnyObject]) {
        self.init()
        self.r_Id = json["_id"] as? Int ?? 0
        if let quarter = json["quarter"] as? String {
            self.pos = String(quarter.split(separator: "-")[1])
        }
        if let mobileData = json["volume_of_mobile_data"]?.floatValue {
            self.data_Used = mobileData
        }
    }
    
}
