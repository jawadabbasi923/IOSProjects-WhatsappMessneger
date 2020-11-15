//
//  LoginViewController.swift
//  WhatsappMessenger
//
//  Created by Jawad Abbasi on 13/11/2020.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    private let scrollView : UIScrollView = {
        
        var scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        
        return scrollView
        
    }()
    
    private let imageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        
        imageView.contentMode = .scaleToFill
        
        return imageView
        
    }()
    
    private let emailTextField : UITextField = {
        
        var field = UITextField()
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter Email"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
        
    }()
    
    private let passwordField : UITextField = {
        
        var field = UITextField()
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        
        return field
        
    }()
    
    private let loginButton : UIButton = {
        
        var loginButton = UIButton()
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .link
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return loginButton
        
    }()
    
    private let fbloginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email, public_profile"]
        return button
    }()
    
    private let googleLoginButton = GIDSignInButton()
    
    private var loginObserver : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver =  NotificationCenter.default.addObserver(forName: .didLoginNotification , object: nil, queue: .main, using:
                                {
                                    [weak self] _ in
                                    
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    
                                    strongSelf.dismiss(animated: true, completion: nil)
                                }
        )
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        title = "Log In"
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTaped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordField.delegate = self
        
        fbloginButton.delegate = self
        
        // Add Sub Views
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(fbloginButton)
        scrollView.addSubview(googleLoginButton)
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 20, width: size, height: size)
        
        emailTextField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        
        passwordField.frame = CGRect(x: 30, y: emailTextField.bottom+10, width: scrollView.width-60, height: 52)
        
        loginButton.frame = CGRect(x: 30, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
        
        fbloginButton.frame = CGRect(x: 30, y: loginButton.bottom+10, width: scrollView.width-60, height: 52)
        
        googleLoginButton.frame = CGRect(x: 30, y: fbloginButton.bottom+10, width: scrollView.width-60, height: 52)
    }
    
    
    @objc private func loginButtonTaped()
    {
        emailTextField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailTextField.text,
              let pass = passwordField.text,
              !email.isEmpty,
              !pass.isEmpty,
              pass.count >= 6
        else {
            alertUserLoginError()
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass, completion:
                                            {
                                                [weak self] authResult, error in
                                                
                                                guard let strongSelf = self else{
                                                    return
                                                }
                                                
                                                guard let res = authResult, error == nil
                                                else
                                                {
                                                    print("Failed to login")
                                                    return
                                                }
                                                
                                                let user = res.user
                                                print("User Logged in \(user)")
                                                
                                                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                                
                                            })
    }
    
    func alertUserLoginError()  {
        
        let alert = UIAlertController(title: "Error", message: "All Fields Mandatory", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
        
    }
    
    @objc private func didTapRegister()
    {
        let vc = RegisterViewController()
        
        vc.title = "Create Account"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension LoginViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField{
            
            passwordField.becomeFirstResponder()
            
        }
        else if textField == passwordField{
            
            loginButtonTaped()
            
        }
        
        return true
    }
}


extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("loginButtonDidLogOut cahnged")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User Failde to login with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start(completionHandler:
                                {
                                    _ , result, error in
                                    guard let reslutdata = result as? [String: Any], error == nil else
                                    {
                                        print("failed to make facebook graph request")
                                        return
                                    }
                                    
                                    //print("\(result)")
                                    
                                    guard let userName = reslutdata["name"] as? String,
                                          let email = reslutdata["email"] as? String else {
                                        print("Failed to get email and name from fb data request")
                                        return
                                        
                                    }
                                    
                                    let nameComponents = userName.components(separatedBy: " ")
                                    guard nameComponents.count == 2 else {
                                        return
                                    }
                                    
                                    let firstN = nameComponents[0]
                                    let lastN = nameComponents[1]
                                    
                                    DatabaseManager.shared.userExists(with: email, complition: { exists in
                                        if !exists {
                                            DatabaseManager.shared.insertUser(with: WhatsappUser(firstName: firstN, lastName: lastN, emailAddress: email))
                                        }
                                    })
                                    
                                    let credential = FacebookAuthProvider.credential(withAccessToken: token)
                                    
                                    FirebaseAuth.Auth.auth().signIn(with: credential, completion:
                                                                        {
                                                                            [weak self] authResult, error in
                                                                            guard let strongSelf = self else {
                                                                                return
                                                                            }
                                                                            guard authResult != nil, error == nil else {
                                                                                print("Login Failed, MFA may need.")
                                                                                return
                                                                            }
                                                                            
                                                                            print("Logged in success")
                                                                            
                                                                            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                                                        }
                                    )
                                }
        )
        
        
    }
    
    
    
    
}
