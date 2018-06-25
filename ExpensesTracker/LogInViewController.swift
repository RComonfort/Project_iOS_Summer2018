//
//  LogInViewController.swift
//  ExpensesTracker
//
//  Created by Alumno on 25/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import UIKit
import LocalAuthentication

class LogInViewController: UIViewController {

    var coreDataManager: CoreDataManager?
    var configurationObject: Configuration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        loadConfiguration()
        if !(configurationObject?.authentication)! {
            performSegue(withIdentifier: "toNavController", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func loadConfiguration(){
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
        let configurations = coreDataManager!.getNSObjects(forEntity: "Configuration")
        
        //Find current configuration object, create one if it doesn't exist
        if (configurations != nil && (configurations?.count)! > 0) {
            configurationObject = (configurations![0] as! Configuration)
        }
        else {
            configurationObject = (coreDataManager!.createEmptyNSObject(ofEntityType: "Configuration") as! Configuration)
            
            _ = coreDataManager!.updateNSObject(object: configurationObject!, values: [true, true, true, true, true], keys: [
                ESettingStrings.Authentication.rawValue,
                ESettingStrings.BudgetNotification.rawValue,
                ESettingStrings.Notifications.rawValue,
                ESettingStrings.SquanderNotification.rawValue,
                ESettingStrings.RecurrentNotification.rawValue
                ])
        }
    }

    @IBAction func logIn(_ sender: Any) {
        let authenticationContext = LAContext()
        var error: NSError?
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlert(title: "Error", message: "This device does not have a Touch ID Sensor")
            _ = coreDataManager?.updateNSObject(object: configurationObject!, values: [false], keys: [ESettingStrings.Authentication.rawValue])
            performSegue(withIdentifier: "toNavController", sender: self)
            return
        }
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Present your fingerprint", reply: {
            [unowned self] (succes, error) -> Void in
            if succes {
                self.performSegue(withIdentifier: "toNavController", sender: self)
            }
            else{
                if let error = error {
                    let message = self.getErrorMessage(code: (error as NSError).code)
                    self.showAlert(title: "Error", message: message)
                }
            }
        })
    }
    
    func getErrorMessage(code: Int) -> String {
        var message = ""
        switch code {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            break
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            break
        case LAError.invalidContext.rawValue:
            message = "The context is not valid"
            break
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set in the device"
            break
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            break
        case LAError.userCancel.rawValue:
            message = "Authentication was cancelled by the user"
            break
        case LAError.userFallback.rawValue:
            message = "User chose to use the fallback"
            break
        default:
            message = "Couldn't recognize message"
            break
        }
        return message
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated:  true)
        }
    }
    
}
