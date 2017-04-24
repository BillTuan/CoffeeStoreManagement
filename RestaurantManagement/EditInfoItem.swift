//
//  EditInfoItem.swift
//  RestaurantManagement
//
//  Created by Bill on 4/23/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class EditInfoItem: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: *** UIVariables
    var food: Food?
    var name = ""
    var category = ""
    var price = ""
    var addImg = ""
    var editbtn = ""
    var imageURL :NSURL?
    var categoryPicker = UIPickerView()
    var idCategory = 0
    //MARK: *** Data Model
    var database: OpaquePointer?
    var Categorys = [Category]()
    //MARK: *** UIElements
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    //MARK: *** UIEvents
    
    @IBAction func addImageTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)

    }
    //MARK: *** UIFunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        database = DB.openDatabase()
        nameLabel.text = name
        categoryLabel.text = category
        priceLabel.text = price
        nameText.text = food?.name
        let currentCate = DBCategory.getCategoryWithID(database: database, id: (food?.category)!)
        categoryText.text = currentCate[0].name
        priceText.text = String(describing: food!.price!)
        imageURL = NSURL(string: (food?.image)!)
        foodImageView.imageFromAssetURL(assetURL: imageURL!)
        addImageButton.setTitle(addImg, for: .normal)
        let edit = UIBarButtonItem(title: editbtn, style: .plain, target: self, action: #selector(endEdit))
        self.navigationItem.rightBarButtonItem = edit
        Categorys = DBCategory.loadCategory(database: database)
        createCategoryPicker()
    }
    func endEdit(_ sender: Any)
    {
        let newFood = Food(idFood: (food?.idFood)!, name: nameText.text!, image: (imageURL?.absoluteString)!, price: Int(priceText.text!)!, category: Categorys[idCategory - 1].idCategory!)
        if DBFood.updateFood(database: database, Food: newFood)
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func createCategoryPicker()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create a button done
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        //Picker view for class
        categoryText.inputAccessoryView = toolbar
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryText.inputView = categoryPicker
        idCategory = (food?.category!)!
        
    }
    
    func donePressed(){
        categoryText.text = Categorys[idCategory - 1].name
        self.view.endEditing(true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let url = info[UIImagePickerControllerReferenceURL] as! NSURL
        self.foodImageView.image = image
        imageURL = url
        picker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Categorys.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Categorys[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        idCategory = Categorys[row].idCategory!
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        name = Localization("Name")
        category = Localization("Category")
        addImg = Localization("AddImage")
        price = Localization("Price")
        editbtn = Localization("Edit")
    }
}
