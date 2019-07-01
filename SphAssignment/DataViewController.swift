//
//  DataViewController.swift
//  SphAssignment
//
//  Created by Deepak Kumar on 28/6/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import UIKit
import RealmSwift

class DataViewController: UITableViewController {
    
    var dataDetails = List<DataDetail>()
    var limit : Int =  56
    var offset : Int = 0
    var isLoading : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.paintView()
    }

    private func paintView()
    {
        DataService.APIUsageDetails(usageDetails: self.dataDetails, offset: self.offset, limit: self.limit) { (isCache, status, message, dataDetails) in self.dataDetails = dataDetails
            
            DispatchQueue.main.async {
                if !status {
                    self.ErrorMessage(errMsg: message)
                }
                self.isLoading = false
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        return cell
    }
    
    private func ErrorMessage(errMsg : String) {
        let alert = UIAlertController(title: "Error", message: errMsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

