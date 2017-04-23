//
//  AddFoodTable.swift
//  RestaurantManagement
//
//  Created by Bill on 4/23/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class AddFoodTable: UITableViewController {
    
    //MARK: - Data model
    var food: Food?
    var Tables = [Table]()
    var name = ""
    var detail = ""
    var area1 = ""
    var chooseTable = ""
    var amountOfFood = ""
    //MARK: - UIVariables
    var database: OpaquePointer?
    //MARK: - UIFunction
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFood_cell", for: indexPath) as! AddFoodTableCell
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: food?.name, message: chooseTable, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textfield: UITextField) in
            textfield.placeholder = self.amountOfFood
            textfield.keyboardType = .numberPad
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) in
            
            if let textfield = alert.textFields?.first
            {
                if textfield.text != ""
                {
                    self.amountOfFood = textfield.text!
                    if self.checkTable(Table: self.Tables[indexPath.row])
                    {
                        self.addNewBill(idTable: self.Tables[indexPath.row].idTable!)
                        self.Tables[indexPath.row].status = 1
                        if  DBTable.updateTable(database: self.database, Table: self.Tables[indexPath.row]){}
                        let currentBill = DBBill.selectBillWithIDTable(database: self.database, id: self.Tables[indexPath.row].idTable!)
                        let newBillInfo = BillInfo(idBill: currentBill[0].idBill!, amountFood: Int(self.amountOfFood)!, idFood: (self.food?.idFood!)!)
                        if DBBillInfo.insertBillInfo(database: self.database, BillInfo: newBillInfo){}
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        let currentBill = DBBill.selectBillWithIDTable(database: self.database, id: self.Tables[indexPath.row].idTable!)
                        let newBillInfo = BillInfo(idBill: currentBill[0].idBill!, amountFood: Int(self.amountOfFood)!, idFood: (self.food?.idFood!)!)
                        if DBBillInfo.insertBillInfo(database: self.database, BillInfo: newBillInfo){}
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkTable(Table: Table) -> Bool
    {
        return (DBBill.selectBillWithIDTable(database: database, id: Table.idTable!).isEmpty)
    }
    
    func addNewBill(idTable: Int)
    {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: currentDate)
        let newBill = Bill(idBill: 0, dateCheckIn: date, totalPrice: 0, status: 0, idTable: idTable)
        if DBBill.insertBill(database: database, Bill: newBill) {}
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    
    
    func configureViewFromLocalisation() {
        self.navigationItem.title = food?.name!
        name = Localization("Name")
        area1 = Localization("Area")
        detail = Localization("Detail")
        chooseTable = Localization("AlertChooseAmountFood")
        amountOfFood = Localization("AmountOfFood")
    }
}
