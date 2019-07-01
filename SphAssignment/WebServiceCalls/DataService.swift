//
//  UsageDetailsTableCell.swift
//  SphAssignment
//
//  Created by Deepak Kumar on 01/7/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class DataService : NSObject {
    
    class func APIUsageDetails(usageDetails: List<DataDetail>, offset: Int, limit: Int, callBack:@escaping (Bool, Bool, String, List<DataDetail>) -> Void) -> Void {
        
        var responseData = List<DataDetail>()
        
        var request = URLRequest(url: URL(string: "https://data.gov.sg/api/action/datastore_search?offset=\(offset)&limit=\(limit)&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f")!)
        
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                guard let httpResponse = response as? HTTPURLResponse else {
                    callBack(false, false, error?.localizedDescription ?? Constant.error, responseData)
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    guard let json = try? JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>, let status = json["success"] as? Int else {
                        callBack(false, false, Constant.error, responseData)
                        return
                    }
                    if status == 1 {
                        DispatchQueue.main.async {
                            if let result = json["result"] as? Dictionary<String, AnyObject> {
                                responseData = JsonParser.parse(json: result, dataDetails: usageDetails)
                                callBack(false, true, "Success", responseData)
                                return
                            } else {
                                callBack(false, false, Constant.error, responseData)
                            }
                        }
                    }
                }
            }
            
        }).resume()
    }
    
}
