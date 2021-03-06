//
//  ChooseFoodViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/17/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class ChooseFoodViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: *** UIVariables
    var amountFood = ""
    var idBill :Int?
    var foodID = ""
    var foodName = ""
    var price = ""
    var chooseFood = ""
    var amountOfFood = ""
    //MARK: *** Data Model
    var database : OpaquePointer?
    var Foods = [Food]()
    var tempFoods = [Food]()
    //MARK: *** UIElements
    @IBOutlet weak var foodTableView: UITableView!
    //MARK: *** UIEvents
    
    //MARK: *** UIFunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadDataTable()
        self.foodTableView.delegate = self
        self.foodTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        setUpSearchBar()
        database = DB.openDatabase()
        tempFoods = DBFood.loadFood(database: database)
        Foods = DBFood.loadFood(database: database)
    }
    
    func loadDataTable()
    {
        Foods.removeAll()
        for Food in tempFoods
        {
            Foods.append(Food)
        }
    }
    enum selectedScope:Int{
        case id = 0
        case name = 1
        case price = 2
    }
    
    func setUpSearchBar()
    {
        let searchFoodBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        searchFoodBar.showsScopeBar = true
        searchFoodBar.scopeButtonTitles = [foodID, foodName, price]
        searchFoodBar.selectedScopeButtonIndex = 0
        searchFoodBar.delegate = self
        self.foodTableView.tableHeaderView = searchFoodBar
    }
    
    //MARK: -Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty
        {
            loadDataTable()
            self.foodTableView.reloadData()
        }
        else
        {
            filterDataWithScope(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func filterDataWithScope(ind: Int, text: String)
    {
        switch ind {
        case selectedScope.id.rawValue:
            Foods = Foods.filter({(mod) -> Bool in
                return (String(describing: mod.idFood).lowercased().contains(text.lowercased()))
            })
            self.foodTableView.reloadData()
        case selectedScope.name.rawValue:
            Foods = Foods.filter({(mod) -> Bool in
                return (mod.name!.lowercased().contains(text.lowercased()))
            })
            self.foodTableView.reloadData()
        case selectedScope.price.rawValue:
            Foods = Foods.filter({(mod) -> Bool in
                return (String(describing: mod.price).lowercased().contains(text.lowercased()))
            })
            self.foodTableView.reloadData()
        default:
            print("not type")
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseFood", for: indexPath) as! ChooseFoodTableViewCell
        

        cell.foodID.text = String(describing: Foods[indexPath.row].idFood!)
        cell.nameFoodLabel.text = Foods[indexPath.row].name
        cell.priceFoodLabel.text = Foods[indexPath.row].price!.toCurrency()
        cell.foodImageView.imageFromAssetURL(assetURL: NSURL(string: Foods[indexPath.row].image!)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: Foods[indexPath.row].name, message: chooseFood, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textfield: UITextField) in
            textfield.placeholder = self.amountOfFood
            textfield.keyboardType = .numberPad
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) in
            
            if let textfield = alert.textFields?.first
            {
                if textfield.text != "" && (Int(textfield.text!) != 0)
                {
                    self.amountFood = textfield.text!
                    if DBBillInfo.selectBillInfoWithIDFood(database: self.database, idInfo: self.idBill!, idFood: self.Foods[indexPath.row].idFood!).isEmpty
                    {
                        let newBillInfo = BillInfo(idBill: self.idBill!, amountFood: Int(self.amountFood)!, idFood: self.Foods[indexPath.row].idFood!)
                        if DBBillInfo.insertBillInfo(database: self.database, BillInfo: newBillInfo){}
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        var currentBillInfo = DBBillInfo.selectBillInfoWithIDFood(database: self.database, idInfo: self.idBill!, idFood: self.Foods[indexPath.row].idFood!)
                        currentBillInfo[0].amountFood = currentBillInfo[0].amountFood! + Int(self.amountFood)!
                        if DBBillInfo.updateBillInfo(database: self.database, BillInfo: currentBillInfo[0]){}
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        foodID = Localization("ItemID")
        foodName = Localization("Name")
        price = Localization("Price")
        chooseFood = Localization("AlertChooseAmountFood")
        amountOfFood = Localization("AmountOfFood")
    }
    
}
