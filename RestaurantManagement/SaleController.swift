//
//  SaleController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/16/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class SaleController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var txtTotalMoney: UILabel!
    @IBOutlet weak var txtRevenue: UILabel!
    @IBOutlet weak var segmentDate: UISegmentedControl!
    @IBOutlet weak var tableFood: UITableView!
    var foodArray : [Food] = []
    var billArray : [Bill] = []
    var billInfoArray : [BillInfo] = []
    var database: OpaquePointer?
    var name = ""
    var amount = ""
    var price = ""
    
    // Process
    var DataBill : [ShowData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        tableFood.delegate = self
        tableFood.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        database = DB.openDatabase()
        foodArray.append(contentsOf: DBFood.loadFood(database: database))
        billArray.append(contentsOf: DBBill.loadBill(database: database))
        billInfoArray.append(contentsOf: DBBillInfo.loadBillInfo(database: database))
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        foodArray = DBFood.loadFood(database: database)
        billArray = DBBill.loadBill(database: database)
        billInfoArray = DBBillInfo.loadBillInfo(database: database)
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataBill.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sale_cell", for: indexPath) as! SaleViewCell
        cell.foodImage.imageFromAssetURL(assetURL: NSURL(string: DataBill[indexPath.row].image)!)
        cell.foodName.text = DataBill[indexPath.row].foodName
        cell.foodQuantity.text = String(DataBill[indexPath.row].foodQuantity)
        cell.foodMoney.text = DataBill[indexPath.row].foodMoney.toCurrency()
        cell.name.text = name
        cell.amount.text = amount
        cell.price.text = price
        return cell
    }
    
    @IBAction func OnSelect(_ sender: Any) {
        // Get date of this day
        let today = Date()
        let calendar = Calendar.current
        let thisday = calendar.component(.day, from: today)
        let thismonth = calendar.component(.month, from: today)
        let thisyear = calendar.component(.year, from: today)
        var totalToday = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        var foodName:[String] = []      // array to get food name
        var foodQuantity:[Int] = []     // array to get food quantity
        
        DataBill.removeAll()
        foodName.removeAll()
        foodQuantity.removeAll()
        if !billInfoArray.isEmpty{
            if(segmentDate.selectedSegmentIndex == 0){      // Today
                for i in 0 ... billArray.count - 1{
                    // get date of string
                    let checkdate = formatter.date(from: billArray[i].dateCheckIn!)
                    let day_checkdate = calendar.component(.day, from: checkdate!)
                    let month_checkdate = calendar.component(.month, from: checkdate!)
                    let year_checkdate = calendar.component(.year, from: checkdate!)
                    
                    if (year_checkdate == thisyear) && (month_checkdate == thismonth) && (day_checkdate == thisday){
                        totalToday = totalToday + billArray[i].totalPrice!
                        for j in 0 ... billInfoArray.count - 1{
                            if billInfoArray[j].idBillInfo == billArray[i].idBill{
                                for m in 0 ... foodArray.count - 1{
                                    if billInfoArray[j].idFood == foodArray[m].idFood{
                                        if foodName.isEmpty{
                                            let newfoodName = foodArray[m].name!
                                            let newfoodQuantity = billInfoArray[j].amountFood!
                                            foodName.append(newfoodName)
                                            foodQuantity.append(newfoodQuantity)
                                        }else{
                                            var check = false
                                            
                                            for n in 0 ... foodName.count - 1{
                                                if foodName[n] == foodArray[m].name!{
                                                    check = true
                                                    foodQuantity[n] += billInfoArray[j].amountFood!
                                                }
                                            }
                                            if check == false{
                                                let newfoodName = foodArray[m].name!
                                                let newfoodQuantity = billInfoArray[j].amountFood!
                                                foodName.append(newfoodName)
                                                foodQuantity.append(newfoodQuantity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else if(segmentDate.selectedSegmentIndex == 1){    // this month
                for i in 0 ... billArray.count - 1{
                    let checkdate = formatter.date(from: billArray[i].dateCheckIn!)
                    let month_checkdate = calendar.component(.month, from: checkdate!)
                    let year_checkdate = calendar.component(.year, from: checkdate!)
                    
                    if (year_checkdate == thisyear) && (month_checkdate == thismonth){
                        totalToday = totalToday + billArray[i].totalPrice!
                        for j in 0 ... billInfoArray.count - 1{
                            if billInfoArray[j].idBillInfo == billArray[i].idBill{
                                for m in 0 ... foodArray.count - 1{
                                    if billInfoArray[j].idFood == foodArray[m].idFood{
                                        if foodName.isEmpty{
                                            let newfoodName = foodArray[m].name!
                                            let newfoodQuantity = billInfoArray[j].amountFood!
                                            foodName.append(newfoodName)
                                            foodQuantity.append(newfoodQuantity)
                                        }else{
                                            var check = false
                                            
                                            for n in 0 ... foodName.count - 1{
                                                if foodName[n] == foodArray[m].name!{
                                                    check = true
                                                    foodQuantity[n] += billInfoArray[j].amountFood!
                                                }
                                            }
                                            if check == false{
                                                let newfoodName = foodArray[m].name!
                                                let newfoodQuantity = billInfoArray[j].amountFood!
                                                foodName.append(newfoodName)
                                                foodQuantity.append(newfoodQuantity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else if(segmentDate.selectedSegmentIndex == 2){    // this year
                for i in 0 ... billArray.count - 1{
                    let checkdate = formatter.date(from: billArray[i].dateCheckIn!)
                    let year_checkdate = calendar.component(.year, from: checkdate!)
                    
                    if (year_checkdate == thisyear){
                        totalToday = totalToday + billArray[i].totalPrice!
                        for j in 0 ... billInfoArray.count - 1{
                            if billInfoArray[j].idBillInfo == billArray[i].idBill{
                                for m in 0 ... foodArray.count - 1{
                                    if billInfoArray[j].idFood == foodArray[m].idFood{
                                        if foodName.isEmpty{
                                            let newfoodName = foodArray[m].name!
                                            let newfoodQuantity = billInfoArray[j].amountFood!
                                            foodName.append(newfoodName)
                                            foodQuantity.append(newfoodQuantity)
                                        }else{
                                            var check = false
                                            
                                            for n in 0 ... foodName.count - 1{
                                                if foodName[n] == foodArray[m].name!{
                                                    check = true
                                                    foodQuantity[n] += billInfoArray[j].amountFood!
                                                }
                                            }
                                            if check == false{
                                                let newfoodName = foodArray[m].name!
                                                let newfoodQuantity = billInfoArray[j].amountFood!
                                                foodName.append(newfoodName)
                                                foodQuantity.append(newfoodQuantity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Add data to DataBill from foodName and foodQuantity
            if foodName.isEmpty == false && foodQuantity.isEmpty == false{
                for i in 0 ... foodName.count - 1{
                    for j in 0 ... foodArray.count - 1{
                        if foodName[i] == foodArray[j].name{
                            let newadd = ShowData(image: foodArray[j].image!, foodName: foodName[i], foodQuantity: foodQuantity[i], foodMoney: foodArray[j].price! * foodQuantity[i])
                            DataBill.append(newadd)
                            
                        }
                    }
                }
            }
        }
        txtTotalMoney.text = totalToday.toCurrency()
        tableFood.reloadData()
    }
     func loadData()
     {
        let today = Date()
        let calendar = Calendar.current
        let thisday = calendar.component(.day, from: today)
        let thismonth = calendar.component(.month, from: today)
        let thisyear = calendar.component(.year, from: today)
        var totalToday = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        var foodName:[String] = []      // array to get food name
        var foodQuantity:[Int] = []     // array to get food quantity
        
        DataBill.removeAll()
        foodName.removeAll()
        foodQuantity.removeAll()
        if !billInfoArray.isEmpty{
            if(segmentDate.selectedSegmentIndex == 0){      // Today
                for i in 0 ... billArray.count - 1{
                    // get date of string
                    let checkdate = formatter.date(from: billArray[i].dateCheckIn!)
                    let day_checkdate = calendar.component(.day, from: checkdate!)
                    let month_checkdate = calendar.component(.month, from: checkdate!)
                    let year_checkdate = calendar.component(.year, from: checkdate!)
                    
                    if (year_checkdate == thisyear) && (month_checkdate == thismonth) && (day_checkdate == thisday){
                        totalToday = totalToday + billArray[i].totalPrice!
                        for j in 0 ... billInfoArray.count - 1{
                            if billInfoArray[j].idBillInfo == billArray[i].idBill{
                                for m in 0 ... foodArray.count - 1{
                                    if billInfoArray[j].idFood == foodArray[m].idFood{
                                        if foodName.isEmpty{
                                            let newfoodName = foodArray[m].name!
                                            let newfoodQuantity = billInfoArray[j].amountFood!
                                            foodName.append(newfoodName)
                                            foodQuantity.append(newfoodQuantity)
                                        }else{
                                            var check = false
                                            
                                            for n in 0 ... foodName.count - 1{
                                                if foodName[n] == foodArray[m].name!{
                                                    check = true
                                                    foodQuantity[n] += billInfoArray[j].amountFood!
                                                }
                                            }
                                            if check == false{
                                                let newfoodName = foodArray[m].name!
                                                let newfoodQuantity = billInfoArray[j].amountFood!
                                                foodName.append(newfoodName)
                                                foodQuantity.append(newfoodQuantity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else if(segmentDate.selectedSegmentIndex == 1){    // this month
                for i in 0 ... billArray.count - 1{
                    let checkdate = formatter.date(from: billArray[i].dateCheckIn!)
                    let month_checkdate = calendar.component(.month, from: checkdate!)
                    let year_checkdate = calendar.component(.year, from: checkdate!)
                    
                    if (year_checkdate == thisyear) && (month_checkdate == thismonth){
                        totalToday = totalToday + billArray[i].totalPrice!
                        for j in 0 ... billInfoArray.count - 1{
                            if billInfoArray[j].idBillInfo == billArray[i].idBill{
                                for m in 0 ... foodArray.count - 1{
                                    if billInfoArray[j].idFood == foodArray[m].idFood{
                                        if foodName.isEmpty{
                                            let newfoodName = foodArray[m].name!
                                            let newfoodQuantity = billInfoArray[j].amountFood!
                                            foodName.append(newfoodName)
                                            foodQuantity.append(newfoodQuantity)
                                        }else{
                                            var check = false
                                            
                                            for n in 0 ... foodName.count - 1{
                                                if foodName[n] == foodArray[m].name!{
                                                    check = true
                                                    foodQuantity[n] += billInfoArray[j].amountFood!
                                                }
                                            }
                                            if check == false{
                                                let newfoodName = foodArray[m].name!
                                                let newfoodQuantity = billInfoArray[j].amountFood!
                                                foodName.append(newfoodName)
                                                foodQuantity.append(newfoodQuantity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else if(segmentDate.selectedSegmentIndex == 2){    // this year
                for i in 0 ... billArray.count - 1{
                    let checkdate = formatter.date(from: billArray[i].dateCheckIn!)
                    let year_checkdate = calendar.component(.year, from: checkdate!)
                    
                    if (year_checkdate == thisyear){
                        totalToday = totalToday + billArray[i].totalPrice!
                        for j in 0 ... billInfoArray.count - 1{
                            if billInfoArray[j].idBillInfo == billArray[i].idBill{
                                for m in 0 ... foodArray.count - 1{
                                    if billInfoArray[j].idFood == foodArray[m].idFood{
                                        if foodName.isEmpty{
                                            let newfoodName = foodArray[m].name!
                                            let newfoodQuantity = billInfoArray[j].amountFood!
                                            foodName.append(newfoodName)
                                            foodQuantity.append(newfoodQuantity)
                                        }else{
                                            var check = false
                                            
                                            for n in 0 ... foodName.count - 1{
                                                if foodName[n] == foodArray[m].name!{
                                                    check = true
                                                    foodQuantity[n] += billInfoArray[j].amountFood!
                                                }
                                            }
                                            if check == false{
                                                let newfoodName = foodArray[m].name!
                                                let newfoodQuantity = billInfoArray[j].amountFood!
                                                foodName.append(newfoodName)
                                                foodQuantity.append(newfoodQuantity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Add data to DataBill from foodName and foodQuantity
            if foodName.isEmpty == false && foodQuantity.isEmpty == false{
                for i in 0 ... foodName.count - 1{
                    for j in 0 ... foodArray.count - 1{
                        if foodName[i] == foodArray[j].name{
                            let newadd = ShowData(image: foodArray[j].image!, foodName: foodName[i], foodQuantity: foodQuantity[i], foodMoney: foodArray[j].price! * foodQuantity[i])
                            DataBill.append(newadd)
                            
                        }
                    }
                }
            }
        }
        
        txtTotalMoney.text = totalToday.toCurrency()
        tableFood.reloadData()

    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    
    func configureViewFromLocalisation() {
        self.navigation.topItem?.title = Localization("BarItem2")
        txtRevenue.text = Localization("Revenue")
        self.segmentDate.setTitle(Localization("Today"), forSegmentAt: 0)
        self.segmentDate.setTitle(Localization("Thismonth"), forSegmentAt: 1)
        self.segmentDate.setTitle(Localization("Thisyear"), forSegmentAt: 2)
        price = Localization("Price")
        name = Localization("Name")
        amount = Localization("Amount")
    }

    
}

struct ShowData {
    var image: String
    var foodName: String
    var foodQuantity: Int
    var foodMoney: Int
    
    init(image: String, foodName: String, foodQuantity: Int, foodMoney: Int) {
        self.image = image
        self.foodName = foodName
        self.foodMoney = foodMoney
        self.foodQuantity = foodQuantity
    }
}
