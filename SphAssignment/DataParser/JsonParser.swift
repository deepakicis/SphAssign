//
//  JsonParser.swift
//  SphAssignment
//
//  Created by Deepak Kumar on 01/7/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class JsonParser : NSObject {

    class func parse(json: Dictionary<String, AnyObject>, dataDetails: List<DataDetail>) -> List<DataDetail> {
        if let records = json["records"] as? [Dictionary<String, AnyObject>] {
            for recordDict in records {
                var year : Int = 0
                if let quarter = recordDict["quarter"] as? String {
                    let yearString = (quarter.components(separatedBy: "-"))[0]
                    year = Int(yearString) ?? 0
                }
                var dataProvided = dataDetails.filter {$0.year == year}.first
                let record = Record(json: recordDict)
                if dataProvided != nil {
                    if (dataProvided?.records.count ?? 0) < 4 {
                        dataProvided?.addRecord(record: record)
                        DatabaseManager.updateData(dataProvided: dataProvided!)
                    }
                } else {
                    dataProvided = DataDetail(record: record)
                    if dataProvided != nil {
                        dataProvided?.year = year
                        dataDetails.append(dataProvided!)
                        if DatabaseManager.getData(year: year).count <= 0{
                            DatabaseManager.addData(dataProvided: dataProvided!)
                        }
                    }
                }
            }
        }
        return dataDetails
    }
    
}
