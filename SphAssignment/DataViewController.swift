//
//  DataViewController.swift
//  SphAssignment
//
//  Created by Deepak Kumar on 28/6/19.
//  Copyright © 2019 Deepak Kumar. All rights reserved.
//

import UIKit

class DataViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        return cell
    }
    
    
}

