//
//  EditInfoTable.swift
//  RestaurantManagement
//
//  Created by Bill on 4/23/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class EditInfoTable: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: *** UIVariables
    var table : Table?
    var name = ""
    var area = ""
    var detail = ""
    var addImg = ""
    var editbtn = ""
    var imageURL :NSURL?
    var areaPicker = UIPickerView()
    var idArea = 0
    //MARK: *** Data Model
    var database: OpaquePointer?
    var Areas = [Area]()
    //MARK: *** UIElements
    
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var areaText: UITextField!
    @IBOutlet weak var detailText: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
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
        areaLabel.text = area
        detailLabel.text = detail
        addImageButton.setTitle(addImg, for: .normal)
        nameText.text = table?.name
        let currentArea = DBArea.selectAreaWithID(database: database, id: (table?.area)!)
        areaText.text = currentArea[0].name
        detailText.text = table?.detail
        imageURL = NSURL(string: (table?.image)!)
        tableImageView.imageFromAssetURL(assetURL: imageURL!)
        idArea = (table?.area)!
        Areas = DBArea.loadArea(database: database)
        let edit = UIBarButtonItem(title: editbtn, style: .plain, target: self, action: #selector(endEdit))
        self.navigationItem.rightBarButtonItem = edit
        createAreaPicker()
    }
    func endEdit(_ sender: Any)
    {
        let newTable = Table(idTable: (table?.idTable)!, name: nameText.text!, detail: detailText.text!, image: (imageURL?.absoluteString)!, status: (table?.status)!, area: Areas[idArea - 1].idArea!)
        if DBTable.updateTable(database: database, Table: newTable)
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func createAreaPicker()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create a button done
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        //Picker view for class
        areaText.inputAccessoryView = toolbar
        areaPicker.dataSource = self
        areaPicker.delegate = self
        areaText.inputView = areaPicker
        idArea = Areas[0].idArea!
        
    }
    
    func donePressed(){
        areaText.text = Areas[idArea - 1].name
        self.view.endEditing(true)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let url = info[UIImagePickerControllerReferenceURL] as! NSURL
        self.tableImageView.image = image
        imageURL = url
        picker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Areas.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Areas[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        idArea = Areas[row].idArea!
    }
    
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        name = Localization("Name")
        detail = Localization("Detail")
        addImg = Localization("AddImage")
        area = Localization("Area")
        editbtn = Localization("Edit")
    }

    
}
