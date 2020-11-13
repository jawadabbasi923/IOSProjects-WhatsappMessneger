//
//  RegisterViewController.swift
//  WhatsappMessenger
//
//  Created by Jawad Abbasi on 13/11/2020.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private let scrollView : UIScrollView = {
        
        var scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        
        return scrollView
        
    }()
    
    private let imageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
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
    
    private let firstNameTextField : UITextField = {
        
        var field = UITextField()
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter First Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
        
    }()
    
    private let lastNameTextField : UITextField = {
        
        var field = UITextField()
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter Last Name"
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
    
    private let registerButton : UIButton = {
        
        var registerButton = UIButton()
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.layer.masksToBounds = true
        registerButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return registerButton
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log In"
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        registerButton.addTarget(self, action: #selector(registerButtonTaped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordField.delegate = self
        
        // Add Sub Views
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        scrollView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedChangeProfile))
        //        gesture.numberOfTouchesRequired = 1
        //        gesture.numberOfTapsRequired = 1
        
        imageView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 20, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        
        firstNameTextField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        
        lastNameTextField.frame = CGRect(x: 30, y: firstNameTextField.bottom+10, width: scrollView.width-60, height: 52)
        
        emailTextField.frame = CGRect(x: 30, y: lastNameTextField.bottom+10, width: scrollView.width-60, height: 52)
        
        passwordField.frame = CGRect(x: 30, y: emailTextField.bottom+10, width: scrollView.width-60, height: 52)
        
        registerButton.frame = CGRect(x: 30, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
    }
    
    @objc private func didTappedChangeProfile()
    {
        //print("Changed")
        presentActionSheet()
    }
    
    @objc private func registerButtonTaped()
    {
        emailTextField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let pass = passwordField.text,
              !email.isEmpty,
              !pass.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              pass.count >= 6
        else {
            alertUserLoginError()
            return
        }
        
        DatabaseManager.shared.userExists(with: email, complition:
                                            {
                                                [weak self] exists in
                                                
                                                guard let strongSelf = self else{
                                                    return
                                                }
                                                
                                                guard !exists else {
                                                    print("User Already registered.")
                                                    strongSelf.alertUserLoginError(message: "User Already Exists.")
                                                    return
                                                }
                                                
                                                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass, completion:
                                                                                        {authResult, error in
                                                                                            guard let strongSelf = self else{
                                                                                                return
                                                                                            }
                                                                                            guard let result = authResult, error == nil else{
                                                                                                print("Errorrrr")
                                                                                                return
                                                                                            }
                                                                                            let user = result.user
                                                                                            print("Created User: \(user)")
                                                                                            
                                                                                            DatabaseManager.shared.insertUser(with: WhatsappUser(firstName: firstName, lastName: lastName, emailAddress: email))
                                                                                            
                                                                                            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                                                                        }
                                                )
                                                
                                            }
        )
        
        
        
    }
    
    func alertUserLoginError(message: String = "All Fields Mendatory")  {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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


extension RegisterViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField{
            
            passwordField.becomeFirstResponder()
            
        }
        else if textField == passwordField{
            
            registerButtonTaped()
            
        }
        
        return true
    }
}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func presentActionSheet()  {
        let actionSheet = UIAlertController(title: "Profle Picture", message: "How would you like to select a picture? ", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default,
                                            handler:
                                                { [weak self] _ in
                                                    self?.presentCamera()
                                                }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default,
                                            handler:
                                                { [weak self] _ in
                                                    self?.presentPhotoGallery()
                                                }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func presentPhotoGallery() {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        //print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else
        {
            return
        }
        self.imageView.image = selectedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
