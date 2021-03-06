//
//  TableViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/16/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    //MARK: *** UIVariables
    var idArea: Int?
    var message = ""
    var title1 = ""
    var cancel = ""
    //MARK: *** Data Model
    var database : OpaquePointer?
    var Tables = [Table]()
    //MARK: *** UIElements
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var TableCollectionView: UICollectionView!
    
    //MARK: *** UIEvents
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: *** UIFunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TableCollectionView.delegate = self
        TableCollectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()

        database = DB.openDatabase()
        Tables = DBTable.getTableWithIDArea(database: database, idArea: idArea!)
    }
    override func viewWillAppear(_ animated: Bool) {
        Tables = DBTable.getTableWithIDArea(database: database, idArea: idArea!)
        self.TableCollectionView.reloadData()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Tables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "table_cell", for: indexPath) as! TableViewCell
        
        //Configure cell
        let title = Tables[indexPath.row].name
        
        cell.numberTableLabel.layer.borderWidth = 1
        cell.numberTableLabel.layer.borderColor = UIColor.black.cgColor
        if Tables[indexPath.row].status! == 1 {
            cell.numberTableLabel.layer.borderWidth = 5
            cell.numberTableLabel.layer.borderColor = UIColor.red.cgColor
        }
        cell.numberTableLabel.text = title
        cell.tableImageView.imageFromAssetURL(assetURL: NSURL(string: Tables[indexPath.row].image!)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyb = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyb.instantiateViewController(withIdentifier: "DetailTable") as! TableDetailViewController
        detailView.tableName = self.Tables[indexPath.row].name!
        detailView.idTable = self.Tables[indexPath.row].idTable!
        if self.Tables[indexPath.row].status! == 0
        {
            let actionAlert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
            actionAlert.addAction(UIAlertAction(title: title1, style: .default, handler: { (UIAlertAction) in
                self.addNewBill(idTable: self.Tables[indexPath.row].idTable!)
                self.Tables[indexPath.row].status = 1
                if  DBTable.updateTable(database: self.database, Table: self.Tables[indexPath.row]){}
                self.navigationController?.pushViewController(detailView, animated: true)

            }))
            actionAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
            self.present(actionAlert, animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.pushViewController(detailView, animated: true)
        }
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
        backButton.title = Localization("Back")
        self.navigationItem.title = Localization("Tables")
        message = Localization("MessageAlertTable")
        title1 = Localization("TittleAlertTable")
        cancel = Localization("AlertCancel")
    }
}
