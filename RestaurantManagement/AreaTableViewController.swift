//
//  AreaTableViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/16/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class AreaTableViewController: UITableViewController {

    //MARK: *** UIVariables
    var database : OpaquePointer?
    @IBOutlet weak var areaTitle: UINavigationItem!
    //MARK: *** Data Model
    var Areas = [Area]()

    //MARK: *** UIFunction
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        
        database = DB.openDatabase()
        DB.createAreaTable(database: database)
        DB.createTableTable(database: database)
        DB.createTableCategory(database: database)
        DB.createTableFood(database: database)
        DB.createTableBill(database: database)
        DB.createTableBillInfo(database: database)

    }

    override func viewWillAppear(_ animated: Bool) {
        Areas = DBArea.loadArea(database: database)
        self.tableView.reloadData()
    }

    // MARK: *** Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Areas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "area_cell", for: indexPath) as! AreaTableViewCell

        // Configure the cell...
        cell.floorLabel.text = Areas[indexPath.row].name
        cell.detailFloorLabel.text = Areas[indexPath.row].detail
        cell.areaImageView.imageFromAssetURL(assetURL: NSURL(string: Areas[indexPath.row].image!)!)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTables"
        {
            let id = tableView.indexPathForSelectedRow
            let des = segue.destination as! UINavigationController
            let target = des.topViewController as! TableViewController
            target.idArea = Areas[(id?.row)!].idArea
        }
    }
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        self.areaTitle.title = Localization("Area")
    }

}
