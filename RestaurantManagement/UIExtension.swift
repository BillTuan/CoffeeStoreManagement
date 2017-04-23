//
//  UIExtension.swift
//  RestaurantManagement
//
//  Created by Bill on 4/18/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension UIViewController{
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    
    func imageFromAssetURL(assetURL: NSURL) {
        
        let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL as URL], options: nil)
        
        //guard let result = asset.firstObject where result is PHAsset else {
        // return
        // }
        if assetURL.absoluteString == ""
        {
            return
        }
        let result = asset.firstObject
        let imageManager = PHImageManager.default()
        
        imageManager.requestImage(for: result! , targetSize: CGSize(width: 500, height: 500), contentMode: PHImageContentMode.aspectFit, options: nil) { (image, dict) -> Void in
            if let image = image {
                self.image = image
            }
        }
    }
}

extension Int{
    func toCurrency() -> String
    {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        let currency = UserDefaults.standard.string(forKey: "Currency")
        if  currency != nil
         {
            currencyFormatter.locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currency!]))
        }
        else{
            currencyFormatter.locale = Locale.current
        }
        let priceString = currencyFormatter.string(from: self as NSNumber)
        return priceString!
    }
}
