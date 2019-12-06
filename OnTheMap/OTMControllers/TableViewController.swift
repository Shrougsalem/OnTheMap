//
//  TableViewController.swift
//  On The Map
//
//  Created by Shroog Salem on 05/12/2019.
//  Copyright © 2019 Shroug Salem. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //MARK: - Properties
    var  locations: [StudentLocation]! {
        return StudentsLocations.sharedObject.studentsLocations
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (locations == nil){
            refreshList(self)
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func LogOutTapped(_ sender: Any) {
        UdacityAPI.deleteSession { (error) in
            if error != nil {
                self.alert(title: "Error", message: error!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshList(_ sender: Any) { UdacityAPI.getStudentLocations { (_, error) in
        if error != nil {
            self.alert(title: "Error", message: "Somthing went wrong!")
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        }
    }
    
    @IBAction func addPin(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "studentLocation") != nil {
            self.overwriteAlert()
        }
        else {
            self.performSegue(withIdentifier: "addNewPin", sender: self)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return locations.count
    }

    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OTMTableCellID", for: indexPath) as! TableViewCell
       // Configure the cell...
        let studentInformation = self.locations[indexPath.row]
        cell.cellConfig(studentInformation: studentInformation)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = locations[indexPath.row]
        guard let openIt = studentLocation.mediaURL, let url = URL(string: openIt) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil )
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
