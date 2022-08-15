//
//  ViewController.swift
//  FindLocation
//
//  Created by detaysoft on 13.08.2022.
//

import UIKit
import JWTDecode

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLoginButton(_ sender: Any) {
        
        if  (nameTextField.text != "") && (passwordTextField.text != ""){
            LoginGet(userName: nameTextField.text!, pass: passwordTextField.text!)
        }
        
    }
  
    func redirectToHome() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "HomePageViewController")
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        self.present(secondVC, animated: true, completion: nil)
    }
    
    func LoginGet(userName :  String, pass : String){
        
        let semaphore = DispatchSemaphore (value: 0)
      //  ["email": userEmail,"password": userPword]
        let parameters = "{\n    \"username\": \"\(userName)\",\n    \"password\": \"\(pass)\"\n\n}"
        print(parameters)
        
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "http://findlocation.eba-udd26rjm.eu-west-2.elasticbeanstalk.com/auth")!,timeoutInterval: Double.infinity)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let userDefaults = UserDefaults.standard
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    userDefaults.set(String(data: data, encoding: .utf8)!, forKey: "token")
                    semaphore.signal()
                    DispatchQueue.main.async {
                        self.redirectToHome()
                    }
                } else {
                    
                }
            }
        }
//        do {
//            let jwt = try decode(jwt: userDefaults.string(forKey: "token")!)
//            print(jwt)
//            print(jwt["body"])
//        } catch {
//            print(error)
//        }
        task.resume()
        semaphore.wait()
        
    }
}

