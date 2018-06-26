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
    var laContext: LAContext!
    
    
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
        coreDataManager = CoreDataManager(inContext: UIApplication.shared.delegate!)
        laContext = LAContext()
        if !setBasicsLogIn(laContext: laContext, coreDataManager: coreDataManager!) {
            mustNotLogIn()
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

    @IBAction func logIn(_ sender: Any) {
        
        doLogIn(laContext: laContext, configurationObject: loadConfiguration(coreDataManager: coreDataManager!), coreDataManager: coreDataManager!)
        
    }
    
}


extension UIViewController{
    
    func setBasicsLogIn(laContext: LAContext, coreDataManager: CoreDataManager) -> Bool{
        let configurationObject = loadConfiguration(coreDataManager: coreDataManager)
        let authenticator = Authenticator()
        authenticator.setFields(context: laContext, config: configurationObject)
        if !authenticator.shallLogIn() {
            return false
        }
        return true
    }
    
    func mustNotLogIn(){
        self.performSegue(withIdentifier: "toNavController", sender: self)
    }
    
    func didLogIn(){
        self.performSegue(withIdentifier: "toNavController", sender: self)
    }
    
    func notEnrrolled () {
        self.performSegue(withIdentifier: "toNavController", sender: self)
        
    }
    
    func loadConfiguration(coreDataManager: CoreDataManager) -> Configuration{
        
        let configurations = coreDataManager.getNSObjects(forEntity: "Configuration")
        var configurationObject: Configuration
        //Find current configuration object, create one if it doesn't exist
        if (configurations != nil && (configurations?.count)! > 0) {
            configurationObject = (configurations![0] as! Configuration)
        }
        else {
            configurationObject = (coreDataManager.createEmptyNSObject(ofEntityType: "Configuration") as! Configuration)
            
            _ = coreDataManager.updateNSObject(object: configurationObject, values: [true, true, true, true, true], keys: [
                ESettingStrings.Authentication.rawValue,
                ESettingStrings.BudgetNotification.rawValue,
                ESettingStrings.Notifications.rawValue,
                ESettingStrings.SquanderNotification.rawValue,
                ESettingStrings.RecurrentNotification.rawValue
                ])
        }
        return configurationObject
    }
    
    func doLogIn(laContext: LAContext, configurationObject: Configuration, coreDataManager: CoreDataManager){
        let authenticator = Authenticator()
        authenticator.setFields(context: laContext, config: configurationObject)
        if authenticator.canLogInWithBiometrics(){
            logInWithBio(laContext: laContext, authenticator: authenticator)
        }
        else{
            if authenticator.canLogIn(){
                logInWithNoBio(laContext: laContext, authenticator: authenticator)
            }
            else{
                _ = coreDataManager.updateNSObject(object: configurationObject, values: [false], keys: [ESettingStrings.Authentication.rawValue])
                self.notEnrrolled()
            }
        }
    }
    
    func logInWithBio(laContext: LAContext, authenticator: Authenticator){
        laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Present your fingerprint", reply: {
            [unowned self] (succes, error) -> Void in
            if succes {
                self.didLogIn()
            }
            else{
                if let error = error {
                    let message = authenticator.getErrorMessage(code: (error as NSError).code)
                    self.showAlert(title: "Error", message: message)
                }
            }
        })
    }
    
    func logInWithNoBio(laContext: LAContext,  authenticator: Authenticator){
        laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Type your password in", reply: {
            [unowned self] (succes, error) -> Void in
            if succes {
                self.didLogIn()
            }
            else{
                if let error = error {
                    let message = authenticator.getErrorMessage(code: (error as NSError).code)
                    self.showAlert(title: "Error", message: message)
                }
            }
        })
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
