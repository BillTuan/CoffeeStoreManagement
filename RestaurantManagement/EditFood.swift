//
//  EditFood.swift
//  RestaurantManagement
//
//  Created by Bill on 4/20/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class EditFood: UITableViewController {

    //MARK: - Data model
    var Foods = [Food]()
    //MARK: - UIVariables
    var database: OpaquePointer?
    var name = ""
    var category1 = ""
    var price = ""
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
        Foods = DBFood.loadFood(database: database)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        Foods = DBFood.loadFood(database: database)
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Foods.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editFood_cell", for: indexPath) as! EditFoodCell

        // Configure the cell...
        cell.name.text = name
        cell.category.text = category1
        cell.price.text = price
        let category = DBCategory.getCategoryWithID(database: database, id: Foods[indexPath.row].category!)
        cell.nameLabel.text = Foods[indexPath.row].name
        cell.categoryLabel.text = category[0].name
        cell.priceLabel.text = Foods[indexPath.row].price!.toCurrency()
        cell.foodImageView.imageFromAssetURL(assetURL: NSURL(string: Foods[indexPath.row].image!)!)
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
            let idcategory = Foods[indexPath.row].category
            DBFood.deleteFood(database: database, id: Foods[indexPath.row].idFood!)
            if DBFood.selectFoodWithIDCategory(database: database, id: idcategory!).isEmpty
            {
                DBCategory.deleteCategory(database: database, id: idcategory!)
            }
            Foods.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editFood"
        {
            let des = segue.destination as! EditInfoItem
            des.food = Foods[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        self.navigationItem.title = Localization("EditFood")
        self.navigationItem.rightBarButtonItem?.title = Localization("Edit")
        name = Localization("Name")
        category1 = Localization("Category")
        price = Localization("Price")
    }
    
}
