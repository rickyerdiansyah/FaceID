//
//  ViewController.swift
//  FaceID
//
//  Created by Ricky Erdiansyah on 27/08/19.
//  Copyright © 2019 Ricky Erdiansyah. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    var logStatus: Bool = false
    
    @IBOutlet weak var switchState: UISwitch!
    
    @IBAction func switchAuthenticator(_ sender: UISwitch) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use biometric authentication
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                reply: {(success, error) in
                    DispatchQueue.main.async {
                        
                        if let err = error {
                            
                            switch err._code {
                                
                            case LAError.Code.systemCancel.rawValue:
                                self.notifyUser("Session cancelled",
                                                err: err.localizedDescription)
                                self.switchState.isOn = false
                                
                            case LAError.Code.userCancel.rawValue:
                                self.notifyUser("Please try again",
                                                err: err.localizedDescription)
                                self.switchState.isOn = false
                                
                            case LAError.Code.userFallback.rawValue:
                                self.notifyUser("Authentication",
                                                err: "Password option selected")
                                // Custom code to obtain password here
                                
                            default:
                                self.notifyUser("Authentication failed",
                                                err: err.localizedDescription)
                                self.switchState.isOn = false
                            }
                            
                        } else {
                            self.notifyUser("Authentication Successful",
                                            err: "You now have full access")
                            if self.logStatus == false{
                                self.logStatus = true
                                
                            }else if self.logStatus == true {
                                self.logStatus = false
                               
                            }
                        }
                    }
            })
            
        } else {
            // Device cannot use biometric authentication
            if let err = error {
                switch err.code {
                    
                case LAError.Code.biometryNotEnrolled.rawValue:
                    notifyUser("User is not enrolled",
                               err: err.localizedDescription)
                    switchState.isOn = false
                    
                case LAError.Code.passcodeNotSet.rawValue:
                    notifyUser("A passcode has not been set",
                               err: err.localizedDescription)
                    
                    
                case LAError.Code.biometryNotAvailable.rawValue:
                    notifyUser("Biometric authentication not available",
                               err: err.localizedDescription)
                    switchState.isOn = false
                default:
                    notifyUser("Unknown error",
                               err: err.localizedDescription)
                    switchState.isOn = false
                }
            }
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

extension ViewController{
    func notifyUser(_ msg: String, err : String?){
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func permissionNotice(_ msg: String, err : String?){
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        
        let allowAction = UIAlertAction(title: "Allow", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(allowAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
