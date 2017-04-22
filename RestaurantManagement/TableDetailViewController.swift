//
//  TableDetailViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/16/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class TableDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: *** UIVariables
    var tableName = ""
    var idTable = 0
    var message = ""
    //MARK: *** Data Model
    var database : OpaquePointer?
    var Bills = [Bill]()
    var BillInfos = [BillInfo]()
    //MARK: *** UIElements
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var addFoodButton: UIButton!
    @IBOutlet weak var billButton: UIButton!
    @IBOutlet weak var moneyTableLabel: UILabel!
    //MARK: *** UIEvents
    
    @IBAction func payButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) in
            self.Bills[0].status = 1
            var thisTable = DBTable.selectTableWithID(database: self.database, idTable: self.idTable)
            thisTable[0].status = 0
            if DBBill.updateBill(database: self.database, Bill: self.Bills[0])
            {
                if DBTable.updateTable(database: self.database, Table: thisTable[0])
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: *** UIFunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        foodTableView.delegate = self
        foodTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()

        moneyTableLabel.text = "0"
        self.navigationItem.title = tableName
        database = DB.openDatabase()
        Bills = DBBill.selectBillWithIDTable(database: database, id: idTable)
        if !Bills.isEmpty{
            BillInfos = DBBillInfo.selectBillInfoWithID(database: database, id: Bills[0].idBill!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if !Bills.isEmpty{
            BillInfos = DBBillInfo.selectBillInfoWithID(database: database, id: Bills[0].idBill!)
            setTotalMoney()
        }
        foodTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BillInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableFood", for: indexPath) as! TableDetailTableViewCell
        
        if !BillInfos.isEmpty
        {
            let food = DBFood.selectFoodWithID(database: database, id: BillInfos[indexPath.row].idFood!)
            cell.FoodImageView.imageFromAssetURL(assetURL: NSURL(string: food[0].image!)!)
            cell.amountFoodLabel.text = String(describing: BillInfos[indexPath.row].amountFood!)
            cell.nameFoodLabel.text = food[0].name
            cell.priceFoodLabel.text = food[0].price!.toCurrency()
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseFood"
        {
            let des = segue.destination as! ChooseFoodViewController
            des.idBill = Bills[0].idBill
        }
    }
    func setTotalMoney()
    {
        var totalMoney = 0
        for bill in BillInfos
        {
            let food = DBFood.selectFoodWithID(database: database, id: bill.idFood!)
            totalMoney = totalMoney + food[0].price!*bill.amountFood!
        }
        Bills[0].totalPrice = totalMoney
        if DBBill.updateBill(database: database, Bill: Bills[0]){}
        self.moneyTableLabel.text = totalMoney.toCurrency()
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        totalMoneyLabel.text = Localization("TotalMoney")
        billButton.setTitle(Localization("Pay"), for: .normal)
        addFoodButton.setTitle(Localization("AddMoreFood"), for: .normal)
        message = Localization("DoYouWantPay")
    }
}
