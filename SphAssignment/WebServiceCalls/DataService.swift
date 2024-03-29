//
//  DataService.swift
//  SphAssignment
//
//  Created by Deepak Kumar on 01/7/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import Foundation
import SystemConfiguration
import RealmSwift

class DataService : NSObject {
    
    class func APIUsageDetails(usageDetails: List<DataDetail>, offset: Int, limit: Int, callBack:@escaping (Bool, Bool, String, List<DataDetail>) -> Void) -> Void {
        
        var responseData = List<DataDetail>()
        if !self.isConnected() {
            responseData = DatabaseManager.getData()
            if responseData.count > 0 {
                callBack(true, false, Constant.noNetwork, responseData)
                return
            }
            callBack(false, false, Constant.noNetworkNoDatabase, responseData)
            return
        }
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
                else if httpResponse.statusCode == 500 {
                    callBack(false, false, Constant.serverError, responseData)
                }
                else if httpResponse.statusCode == 404 {
                    callBack(false, false, Constant.serverNotFoundError, responseData)
                }
                else {
                    callBack(false, false, Constant.error, responseData)
                }
            }
            
        }).resume()
    }
    
    class func isConnected() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let reachability = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let reqCon = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let result = (reachability && !reqCon)
        return result
    }
}
