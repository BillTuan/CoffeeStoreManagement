//
//  EditInfoArea.swift
//  RestaurantManagement
//
//  Created by Bill on 4/23/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class EditInfoArea: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: *** UIVariables
    var area:Area?
    var name = ""
    var detail = ""
    var addImg = ""
    var editbtn = ""
    var imageURL :NSURL?
    //MARK: *** Data Model
    var database: OpaquePointer?

    //MARK: *** UIElements
    
    @IBOutlet weak var areaImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var detailText: UITextField!
    
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
        nameLabel.text = name
        detailLabel.text = detail
        addImageButton.setTitle(addImg, for: .normal)
        nameText.text = area?.name
        detailText.text = area?.detail
        areaImageView.imageFromAssetURL(assetURL: NSURL(string: (area?.image!)!)!)
        imageURL = NSURL(string: (area?.image!)!)!
        database = DB.openDatabase()
        let edit = UIBarButtonItem(title: editbtn, style: .plain, target: self, action: #selector(endEdit))
        self.navigationItem.rightBarButtonItem = edit
    }
    
    func endEdit(_ sender: Any)
    {
        let editArea = Area(idArea: (area?.idArea)!, name: nameText.text!, detail: detailText.text!, image: (imageURL?.absoluteString)!)
        
        if DBArea.updateArea(database: database, Area: editArea)
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let url = info[UIImagePickerControllerReferenceURL] as! NSURL
        self.areaImageView.image = image
        imageURL = url
        picker.dismiss(animated: true, completion: nil)
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
        editbtn = Localization("Edit")
    }

}
