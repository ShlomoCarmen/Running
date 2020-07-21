//
//  Utils.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 05/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    // MARK: - Alerts
    class func showAlertMessage(_ message:String ,viewControler:UIViewController){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            viewControler.present(alertController, animated: true, completion: nil)
        }
    }
    class func showAlertMessage(_ message:String,title:String?,viewControler:UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            viewControler.present(alertController, animated: true, completion: nil)
        }
    }
    class func showAlertMessage(_ message:String,title:String?,viewControler:UIViewController,handler:@escaping ((_ action:UIAlertAction)->Void)){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            viewControler.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlertMessage(_ message:String,title:String?,viewControler:UIViewController,actions:[UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async {
            viewControler.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Parsing and Conversion
    
    class func convertDataToJSONObject(_ data:Data)-> Any?{
        do {
            let obj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            return obj
        }
            
        catch {
            return nil
        }
    }
    
    class func convertDataToDictionary(_ data:Data)->Dictionary<String,Any>?{
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? Dictionary<String,Any>
            return dictionary
        }
            
        catch let error as NSError{
            NSLog("Could not create dictionary from string, with error: \(error)")
            return nil
        }
    }
    
    // MARK: - UI
    
    class func dropViewShadow(view: UIView, shadowColor: UIColor, shadowRadius: CGFloat, shadowOffset: CGSize) {
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = shadowRadius
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false

    }
}
