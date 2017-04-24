//
//  EditTable.swift
//  RestaurantManagement
//
//  Created by Bill on 4/20/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class EditTable: UITableViewController {
    
    //MARK: - Data model
    var Tables = [Table]()
    var name = ""
    var detail = ""
    var area1 = ""
    //MARK: - UIVariables
    var database: OpaquePointer?
    //MARK: - UIFunction
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        database = DB.openDatabase()
        Tables = DBTable.loadTable(database: database)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Tables = DBTable.loadTable(database: database)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Tables.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTable_cell", for: indexPath) as! EditTableCell
        
        // Configure the cell...
        cell.name.text = name
        cell.area.text = area1
        cell.detail.text = detail
        cell.nameLabel.text = Tables[indexPath.row].name
        let area = DBArea.selectAreaWithID(database: database, id: Tables[indexPath.row].area!)
        cell.areaLabel.text = area[0].name
        cell.detailLabel.text = Tables[indexPath.row].detail
        cell.tableImageView.imageFromAssetURL(assetURL: NSURL(string: Tables[indexPath.row].image!)!)
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            DBTable.deleteTable(database: database, id: Tables[indexPath.row].idTable!)
            Tables.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTable"
        {
            let des = segue.destination as! EditInfoTable
            des.table = Tables[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        self.navigationItem.title = Localization("EditTable")
        self.navigationItem.rightBarButtonItem?.title = Localization("Edit")
        name = Localization("Name")
        area1 = Localization("Area")
        detail = Localization("Detail")

    }
}
