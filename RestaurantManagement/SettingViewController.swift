//
//  SettingViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/18/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    //MARK: - Variable
    let arrayLanguages = Localisator.sharedInstance.getArrayAvailableLanguages()
    var cancel1 = ""
    var message = ""
    //MARK: - Elements
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var currentLan: UIButton!
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    //MARK: - Events
    @IBAction func languageButtonTapped(_ sender: Any) {
        
        let actionAlert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: "English", style: .default, handler: { (UIAlertAction) in
            self.languageButton.setTitle("English", for: .normal)
            if SetLanguage(self.arrayLanguages[1]){};
        }))
        actionAlert.addAction(UIAlertAction(title: "Tiếng Việt", style: .default, handler: { (UIAlertAction) in
            self.languageButton.setTitle("Tiếng Việt", for: .normal)
            if SetLanguage(self.arrayLanguages[2]){}
        }))
        let cancel = cancel1
        actionAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        self.present(actionAlert, animated: true, completion: nil)
    }
    //MARK: - Function
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.receiveLanguageChangedNotification(notification:)), name: kNotificationLanguageChanged, object: nil)
        configureViewFromLocalisation()
        Localisator.sharedInstance.saveInUserDefaults = true
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 
    }
    func receiveLanguageChangedNotification(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureViewFromLocalisation()
        }
    }
    func configureViewFromLocalisation() {
        currentLan.setTitle(Localization("currentLang"), for: .normal)
        self.navigationItem.title = Localization("Setting")
        editLabel.text = Localization("EditStore")
        languageLabel.text = Localization("Language")
        editButton.setTitle(Localization("EditStore"), for: .normal)
        cancel1 = Localization("AlertCancel")
        message = Localization("ChooseLaguage")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
