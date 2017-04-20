//
//  SettingViewController.swift
//  RestaurantManagement
//
//  Created by Bill on 4/18/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    //MARK: - Elements
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    //MARK: - Events
    @IBAction func languageButtonTapped(_ sender: Any) {
        let message = NSLocalizedString("ChooseLaguage", comment: "")
        let actionAlert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: "English", style: .default, handler: { (UIAlertAction) in
            self.languageButton.setTitle("English", for: .normal)
        }))
        actionAlert.addAction(UIAlertAction(title: "Tiếng Việt", style: .default, handler: { (UIAlertAction) in
            self.languageButton.setTitle("Tiếng Việt", for: .normal)
        }))
        let cancel = NSLocalizedString("AlertCancel", comment: "")
        actionAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        self.present(actionAlert, animated: true, completion: nil)
    }
    //MARK: - Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Setting", comment: "")
        editLabel.text = NSLocalizedString("Edit", comment: "")
        languageLabel.text = NSLocalizedString("Language", comment: "")
        editButton.setTitle(NSLocalizedString("EditStore", comment: ""), for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 
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
