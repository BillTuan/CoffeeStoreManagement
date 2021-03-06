//
//  EditViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/17/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: *** Data Model
    var Areas = [Area]()
    var Categorys = [Category]()
    var Foods = [Food]()
    var currency = Locale.commonISOCurrencyCodes
    //MARK: *** UIVariables
    var database: OpaquePointer?
    var areaImage: NSURL?
    var tableImage: NSURL?
    var itemImage: NSURL?
    var whichImage = 1
    var areaPicker = UIPickerView()
    var categoryPicker = UIPickerView()
    var currencyPicker = UIPickerView()
    var tableArea = ""
    var idArea : Int?
    var idCategory: Int?
    var whichPicker : Int?
    var foodCategory = ""
    var storeCurrency = ""
    var symbolCurrency = ""
    var warning = ""
    var namemust = ""
    var nameAndAreamust = ""
    var idmust = ""
    var iditem = ""
    var areaempty = ""
    //MARK: *** UIElements
    //MARK: Label
    @IBOutlet weak var storeInfoLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAdressLabel: UILabel!
    @IBOutlet weak var storeCurrencyLabel: UILabel!
    @IBOutlet weak var storeAreaLabel: UILabel!
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var areaDetailLabel: UILabel!
    @IBOutlet weak var storeTableLabel: UILabel!
    @IBOutlet weak var tableNameLabel: UILabel!
    @IBOutlet weak var tableAreaLabel: UILabel!
    @IBOutlet weak var tableDetailLabel: UILabel!
    @IBOutlet weak var menuItemLabel: UILabel!
    @IBOutlet weak var itemIDLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemCategoryLabel: UILabel!
    //MARK: TextField
    @IBOutlet weak var storeNameText: UITextField!
    @IBOutlet weak var storeAdrressText: UITextField!
    @IBOutlet weak var storeCurrencyText: UITextField!
    @IBOutlet weak var areaNameText: UITextField!
    @IBOutlet weak var areaDetailText: UITextField!
    @IBOutlet weak var tableNameText: UITextField!
    @IBOutlet weak var tableAreaText: UITextField!
    @IBOutlet weak var tableDetailText: UITextField!
    @IBOutlet weak var itemIDText: UITextField!
    @IBOutlet weak var itemNameText: UITextField!
    @IBOutlet weak var itemPriceText: UITextField!
    @IBOutlet weak var itemCategoryText: UITextField!
    //MARK: ImageView
    @IBOutlet weak var areaImageView: UIImageView!
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var addAreaButton: UIButton!
    @IBOutlet weak var editAreaButton: UIButton!
    @IBOutlet weak var addTableButton: UIButton!
    @IBOutlet weak var editTableButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var editItemButton: UIButton!
    
    //MARK: *** UIEvents
    @IBAction func addAreaTapped(_ sender: Any) {
        
        if (areaNameText.text?.isEmpty)!
        {
            self.showAlert(title: warning, message: namemust)
        }
        else
        {
            let newArea = Area(idArea: 0, name: areaNameText.text!, detail: areaDetailText.text!, image: (areaImage?.absoluteString ?? ""))
            if DBArea.insertArea(database: database, Area: newArea)
            {
                self.showAlert(title: "", message: "Success insert new Area")
                areaNameText.text = ""
                areaDetailText.text = ""
            }
        }
    }
    
    @IBAction func addTableTapped(_ sender: Any) {

        if ((tableNameText.text?.isEmpty)! || (tableAreaText.text?.isEmpty)!)
        {
            self.showAlert(title: warning, message: nameAndAreamust)
        }
        else
        {
            let newTable = Table(idTable: 1, name: tableNameText.text!, detail: tableDetailText.text!, image: (tableImage?.absoluteString ?? ""), status: 0, area: idArea!)
            if DBTable.insertTable(database: database, Table: newTable)
            {
        
                self.showAlert(title: "", message: "Success insert Table")
                tableNameText.text = ""
                tableAreaText.text = ""
                tableDetailText.text = ""
            }
        }
    }
    @IBAction func addItemTapped(_ sender: Any) {
        if ((itemIDText.text?.isEmpty)! || (itemNameText.text?.isEmpty)! || (itemCategoryText.text?.isEmpty)!)
        {
            self.showAlert(title: warning, message: idmust)
        }
        else if !DBFood.selectFoodWithID(database: database, id: Int(itemIDText.text!)!).isEmpty
        {
            self.showAlert(title: warning, message: iditem)
        }

        else{
            let newFood = Food(idFood: Int(itemIDText.text!)!, name: itemNameText.text!, image: (itemImage?.absoluteString ?? ""), price: Int(itemPriceText.text!)!, category: idCategory!)
            if DBFood.insertFood(database: database, Food: newFood)
            {
                showAlert(title: "Success insert food", message: "")
                itemIDText.text = ""
                itemNameText.text = ""
                itemPriceText.text = ""
                itemCategoryText.text = ""
            }
        }
    }
    @IBOutlet weak var saveContentTapped: UIButton!
    
    //MARK: *** UIFunctions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        addTapGestureImageView()
        database = DB.openDatabase()
        tableAreaText.addTarget(self, action: #selector(pickArea), for: .editingDidBegin)
        itemCategoryText.addTarget(self, action: #selector(pickCategory), for: .editingDidBegin)
        storeCurrencyText.addTarget(self, action: #selector(pickCurrency), for: .editingDidBegin)
        storeNameText.addTarget(self, action: #selector(saveName), for: .editingDidEnd)
        storeAdrressText.addTarget(self, action: #selector(saveAddress), for: .editingDidEnd)
    }
    
    func pickArea(_ sender: Any)
    {
        Areas = DBArea.loadArea(database: database)
        if !Areas.isEmpty
        {
            createAreaPicker()
        }
        else
        {
            showAlert(title: "", message: areaempty)
        }
    }
    
    func pickCategory(_ sender: Any)
    {
        Categorys = DBCategory.loadCategory(database: database)
        createCategoryPicker()
    }
    func pickCurrency(_ sender: Any)
    {
        createCurrencyPicker()
    }
    
    func saveName(_ sender : Any)
    {
        UserDefaults.standard.set(storeNameText.text!, forKey: "Name")
    }
    
    func saveAddress(_ sender: Any)
    {
        UserDefaults.standard.set(storeAdrressText.text!, forKey: "Address")
    }
    func setLabelView()
    {
        self.navigationItem.title = Localization("EditStore")
        storeInfoLabel.text = Localization("StoreInfo")
        storeNameLabel.text = Localization("Name")
        storeAdressLabel.text = Localization("Address")
        storeCurrencyLabel.text = Localization("Currency")
        storeAreaLabel.text = Localization("StoreArea")
        areaNameLabel.text = Localization("Area")
        areaDetailLabel.text = Localization("Detail")
        storeTableLabel.text = Localization("StoreTable")
        tableNameLabel.text = Localization("Name")
        tableAreaLabel.text = Localization("Area")
        tableDetailLabel.text = Localization("Detail")
        menuItemLabel.text = Localization("MenuItem")
        itemIDLabel.text = Localization("ItemID")
        itemNameLabel.text = Localization("ItemName")
        itemPriceLabel.text = Localization("Price")
        itemCategoryLabel.text = Localization("Category")
        addAreaButton.setTitle(Localization("Add"), for: .normal)
        addTableButton.setTitle(Localization("Add"), for: .normal)
        addItemButton.setTitle(Localization("Add"), for: .normal)
        editAreaButton.setTitle(Localization("Edit"), for: .normal)
        editTableButton.setTitle(Localization("Edit"), for: .normal)
        editItemButton.setTitle(Localization("Edit"), for: .normal)
        if UserDefaults.standard.string(forKey: "Currency") != nil{
            storeCurrencyText.text = UserDefaults.standard.string(forKey: "Currency")! + "|" + UserDefaults.standard.string(forKey: "Symbol")!
        }
        if UserDefaults.standard.string(forKey: "Name") != nil
        {
                storeNameText.text = UserDefaults.standard.string(forKey: "Name")!
        }
        if UserDefaults.standard.string(forKey: "Address") != nil
        {

                storeAdrressText.text = UserDefaults.standard.string(forKey: "Address")!

        }
    }
    
    func addTapGestureImageView()
    {
        let tappAreaImage = UITapGestureRecognizer(target: self, action: #selector(pickAreaImage))
        tappAreaImage.numberOfTapsRequired = 1
        let tappTableImage = UITapGestureRecognizer(target: self, action: #selector(pickTableImage))
        tappTableImage.numberOfTapsRequired = 1
        let tappItemImage = UITapGestureRecognizer(target: self, action: #selector(pickItemImage))
        tappItemImage.numberOfTapsRequired = 1
        self.itemImageView.isUserInteractionEnabled = true
        self.tableImageView.isUserInteractionEnabled = true
        self.areaImageView.isUserInteractionEnabled = true
        self.areaImageView.addGestureRecognizer(tappAreaImage)
        self.tableImageView.addGestureRecognizer(tappTableImage)
        self.itemImageView.addGestureRecognizer(tappItemImage)
    }
    //MARK: *** ImageView
    func pickAreaImage()
    {
        whichImage = 1
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func pickTableImage()
    {
        whichImage = 2
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func pickItemImage()
    {
        whichImage = 3
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let url  = info[UIImagePickerControllerReferenceURL] as! NSURL

        switch whichImage {
        case 1:
            self.areaImage = url
            self.areaImageView.image = image
        case 2:
            tableImage = url
            tableImageView.image = image
        case 3:
            itemImageView.image = image
            itemImage = url
        default: break
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK: *** PickerView
    
    func createAreaPicker()
    {
        // Create a tool bar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create a button done
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedArea))
        toolbar.setItems([doneButton], animated: false)
        
        //Picker view for class
        tableAreaText.inputAccessoryView = toolbar
        tableAreaText.inputView = areaPicker
        
        whichPicker = 1
        areaPicker.delegate = self
        areaPicker.dataSource = self
        tableArea = Areas[0].name!
        idArea = 1
        
    }
    
    func createCategoryPicker()
    {
        // Create a tool bar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Create button toolbar
        var addButton = [UIBarButtonItem]()
        addButton.append(UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedCategory)))
        addButton.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        addButton.append(UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addPressedCategory)))
        toolbar.setItems(addButton, animated: false)
        //Picker view for class
        itemCategoryText.inputAccessoryView = toolbar
        itemCategoryText.inputView = categoryPicker
        
        whichPicker = 2
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        if !Categorys.isEmpty
        {
            foodCategory = Categorys[0].name!
            idCategory = Categorys[0].idCategory
        }
        
    }
    func createCurrencyPicker()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create a button done
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedCurrency))
        toolbar.setItems([doneButton], animated: false)
        
        //Picker view for class
        storeCurrencyText.inputAccessoryView = toolbar
        storeCurrencyText.inputView = currencyPicker
        
        whichPicker = 3
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        storeCurrency = currency[0]
    }
    
    func donePressedArea(){
        tableAreaText.text = tableArea
        self.view.endEditing(true)
    }
    
    func donePressedCategory(){
        itemCategoryText.text = foodCategory
        self.view.endEditing(true)
    }
    
    func donePressedCurrency(){
        
        symbolCurrency = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : storeCurrency])).currencySymbol!
        storeCurrencyText.text = storeCurrency + "|" + symbolCurrency
        UserDefaults.standard.set(storeCurrency, forKey: "Currency")
        UserDefaults.standard.set(symbolCurrency, forKey: "Symbol")
        self.view.endEditing(true)
    }

    
    func addPressedCategory(){
        let alert = UIAlertController(title: "", message: NSLocalizedString("AddNewCategory", comment: ""), preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textfield: UITextField) in
            textfield.placeholder = NSLocalizedString("Name", comment: "")
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) in
            
            if let textfield = alert.textFields?.first
            {
                if textfield.text != ""
                {
                    //self.itemCategoryText.text = textfield.text!
                    if DBCategory.insertCategory(database: self.database, Category: Category(idCategory: 0, name: textfield.text!))
                    {
                        self.showAlert(title: "Success insert category", message: "")
                    }
                    self.view.endEditing(true)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if whichPicker == 1
        {
            return Areas.count
        }
        else if whichPicker == 2
        {
            return Categorys.count
        }
        else
        {
            return currency.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if whichPicker == 1
        {
            return Areas[row].name
        }
        else if whichPicker == 2
        {
            return Categorys[row].name
        }
        else{
            symbolCurrency = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : currency[row]])).currencySymbol!
            return currency[row] + "|" + symbolCurrency
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if whichPicker == 1
        {
            tableArea = Areas[row].name!
            idArea = row + 1
        }
        else if whichPicker == 2
        {
            if !Categorys.isEmpty {
                foodCategory = Categorys[row].name!
                idCategory = row + 1
            }
        }
        else
        {
            storeCurrency = currency[row]
        }
    }
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        setLabelView()
        warning = Localization("Warning")
        namemust = Localization("Namemust")
        nameAndAreamust = Localization("Nameandareamust")
        idmust = Localization("Idmust")
        iditem = Localization("Itemexist")
        areaempty = Localization("Areaempty")
    }
}
