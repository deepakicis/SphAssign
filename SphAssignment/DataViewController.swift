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

        cell.lblYear.text = "Year : " + String(describing: self.dataDetails[indexPath.row].year)
        cell.lblDataConsumption.text = "Total mobile data usage: " + String(describing: self.dataDetails[indexPath.row].dataVolume)
        
        if !self.dataDetails[indexPath.row].isDecreaseVolumeData {
            cell.decreaseVolumeDataImg.isHidden = true
        }
        else {
            cell.decreaseVolumeDataImg.isHidden = false
            cell.decreaseVolumeDataBtn.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
        }
        
        if(indexPath.row == (self.dataDetails.count-1)) && !self.isLoading {
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.startAnimating()
            indicator.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 44.0)
            self.tableView.tableFooterView = indicator
            self.tableView.tableFooterView?.isHidden = false
        }
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            self.offset += self.limit
            self.limit = 5
            self.paintView()
        }
    }
    
    @objc func pressButton(_ sender: UIButton) {
        self.ErrorMessage(errMsg: "Demonstrates a decrease in volume data.")
    }
    
    private func ErrorMessage(errMsg : String) {
        let alert = UIAlertController(title: "Error", message: errMsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

