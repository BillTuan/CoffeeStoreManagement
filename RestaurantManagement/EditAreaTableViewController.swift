//
//  EditAreaTableViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/19/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class EditAreaTableViewController: UITableViewController {

    //MARK: - Data model
    var Areas = [Area]()
    //MARK: - UIVariables
    var database: OpaquePointer?

    //MARK: - UIFunction
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = NSLocalizedString("EditArea", comment: "")
        database = DB.openDatabase()
        Areas = DBArea.loadArea(database: database)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Areas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editArea_cell", for: indexPath) as! EditAreaTableViewCell

        // Configure the cell...
        cell.name.text = NSLocalizedString("Name", comment: "")
        cell.detail.text = NSLocalizedString("Detail", comment: "")
        cell.nameLabel.text = Areas[indexPath.row].name
        cell.detailLabel.text = Areas[indexPath.row].detail
        cell.areaImageView.imageFromAssetURL(assetURL: NSURL(string:Areas[indexPath.row].image!)!)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            DBTable.deleteTableWithIDArea(database: database, id: Areas[indexPath.row].idArea!)
            DBArea.deleteArea(database: database, id: Areas[indexPath.row].idArea!)
            Areas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
        
    }
}
