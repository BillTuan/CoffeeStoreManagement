//
//  MenuController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/16/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

import UIKit

class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate {
    
    //MARK: *** UIVariables
    var database: OpaquePointer?
    var name = ""
    var price = ""
    var foodID = ""
    var search = [String]()
    var searchFoodBar = UISearchBar()
    //MARK: *** Data Model
    var Categorys = [Category]()
    var Foods = [[Food]]()
    var tempFoods = [[Food]]()
    //MARK: *** UIElements
    @IBOutlet weak var menuTableView: UITableView!
    //MARK: *** UIEvents
    
    //MARK: *** UIFunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        database = DB.openDatabase()
        Categorys = DBCategory.loadCategory(database: database)
        for cate in Categorys{
            tempFoods.append(DBFood.selectFoodWithIDCategory(database: database, id: cate.idCategory!))
        }
        loadFood()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        setUpSearchBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        Categorys = DBCategory.loadCategory(database: database)
        for cate in Categorys{
            tempFoods.append(DBFood.selectFoodWithIDCategory(database: database, id: cate.idCategory!))
        }
        loadFood()
        menuTableView.reloadData()
    }
    func loadFood(){
        for cate in Categorys{
            Foods.append(DBFood.selectFoodWithIDCategory(database: database, id: cate.idCategory!))
        }
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
        searchFoodBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        searchFoodBar.showsScopeBar = true
        searchFoodBar.scopeButtonTitles = search
        searchFoodBar.selectedScopeButtonIndex = 0
        searchFoodBar.delegate = self
        self.menuTableView.tableHeaderView = searchFoodBar
    }
    
    //MARK: -Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty
        {
            loadDataTable()
            self.menuTableView.reloadData()
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
            for i in 0..<Categorys.count
            {
                Foods[i] = Foods[i].filter({(mod) -> Bool in
                    return (String(mod.idFood!).lowercased().contains(text.lowercased()))
                })
            }
            self.menuTableView.reloadData()
        case selectedScope.name.rawValue:
            for i in 0..<Categorys.count
            {
                Foods[i] = Foods[i].filter({(mod) -> Bool in
                    return (mod.name!.lowercased().contains(text.lowercased()))
                })
            }
            self.menuTableView.reloadData()
        case selectedScope.price.rawValue:
            for i in 0..<Categorys.count
            {
                Foods[i] = Foods[i].filter({(mod) -> Bool in
                    return (String(mod.price!).lowercased().contains(text.lowercased()))
                })
            }
            self.menuTableView.reloadData()
        default:
            print("not type")
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Categorys.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Foods[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Categorys[section].name!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell", for: indexPath) as! MenuViewCell
        
        cell.foodImageView.imageFromAssetURL(assetURL: NSURL(string: Foods[indexPath.section][indexPath.row].image!)!)
        cell.name.text = name
        cell.price.text = price
        cell.nameLabel.text = Foods[indexPath.section][indexPath.row].name!
        cell.priceLabel.text = Foods[indexPath.section][indexPath.row].price?.toCurrency()
        cell.idLabel.text = String(Foods[indexPath.section][indexPath.row].idFood!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyb = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyb.instantiateViewController(withIdentifier: "addFood") as! AddFoodTable
        detailView.food = Foods[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    
    func configureViewFromLocalisation() {
        search.removeAll()
        name = Localization("Name")
        price = Localization("Price")
        foodID = Localization("FoodID")
        search.append(foodID)
        search.append(name)
        search.append(price)
        searchFoodBar.scopeButtonTitles = search
    }
    
}
