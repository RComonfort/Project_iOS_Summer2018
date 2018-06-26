//
//  Authenticator.swift
//  ExpensesTracker
//
//  Created by Alumno on 26/06/18.
//  Copyright © 2018 Comonfort. All rights reserved.
//

import Foundation
import LocalAuthentication

class Authenticator: NSObject {
    
    var authenticationContext: LAContext!
    var configuration: Configuration!
    
    func setFields(context: LAContext, config: Configuration) {
        
        self.authenticationContext = context
        self.configuration = config
    }
    
    func canLogInWithBiometrics() -> Bool{
        
        var error: NSError?
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print(error!)
            print("cant bio")
            return false
        }
        print("can bio")
        return true
        
    }
    
    func canLogIn() -> Bool{
        var error: NSError?
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("cant normal")
            return false
        }
        print("can normal")
        return true
    }
    
    
    func shallLogIn() -> Bool{
        return configuration.authentication
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
    
    
}
