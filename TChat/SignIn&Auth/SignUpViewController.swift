//
//  SignUpViewController.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import UIKit

class  SignUpViewController: UIViewController {
    
    //    let welcomeLable = UILabel(text: "WELCOME!", font: .avenir26())
        let welcomeImage = UIImageView(image: #imageLiteral(resourceName: "welcome"), contentMode: .scaleAspectFill)
        let bgImage = UIImageView(image: #imageLiteral(resourceName: "bg5"), contentMode: .scaleAspectFill)

        
        let emailLable = UILabel(text: "Email")
        let passwordLable = UILabel(text: "Password")
        let confirmPasswordLable = UILabel(text: "Confirm password")
        let alreadyOnBoardLable = UILabel(text: "Already onboard?")
        
        let emailTextField = OneLineTextField(font: .avenir20())
        let passwordTextField = OneLineTextField(font: .avenir20())
        let confirmPasswordTextField = OneLineTextField(font: .avenir20())
        
        let signUpButton = UIButton(title: "Sign Up", titleColor: #colorLiteral(red: 0.0980392918, green: 0.3725489676, blue: 0.1568627357, alpha: 1), backgroundColor: #colorLiteral(red: 0.9176471829, green: 0.9058822393, blue: 0.6705883145, alpha: 1), cornerrRadius: 10)
        
        let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
            return button
        }()
        
        weak var delegate: AuthNavigationDelegate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            hideKeyboardWhenTappedAround()
            
            view.backgroundColor = .white
            setupConstrains()
            
            signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
    
        
        @objc private func signUpButtonTapped() {
            print(#function)
            AuthService.shared.register(email: emailTextField.text,
                                        password: passwordTextField.text,
                                        confirmPassword: confirmPasswordTextField.text) { (result) in
                                            switch result {
                                                
                                            case .success(let user):
                                                self.showAlert(with: "Вітаю!", and: "Ви зареєстровані!") {
                                                    self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil )
                                                }
                                            case .failure(let error):
                                                self.showAlert(with: "FATALITY", and: error.localizedDescription)
                                            }
                                        }
        }
        
        @objc private func loginButtonTapped() {
            self.dismiss(animated: true) {
                self.delegate?.toLoginVC()
            }
        }
    }

    // MARK - Setup Constrains
    extension SignUpViewController {
        private func setupConstrains() {
            let emailStackView = UIStackView(arrangedSubviews: [emailLable, emailTextField], axis: .vertical, spacing: 0)
            let passwordStackView = UIStackView(arrangedSubviews: [passwordLable, passwordTextField], axis: .vertical, spacing: 0)
            let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLable, confirmPasswordTextField], axis: .vertical, spacing: 0)
            
            signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            let stackView = UIStackView(arrangedSubviews: [
                emailStackView,
                passwordStackView,
                confirmPasswordStackView,
                signUpButton],
                                        axis: .vertical,
                                        spacing: 40)
            
            
            loginButton.contentHorizontalAlignment = .leading
            let bottomStackView = UIStackView(arrangedSubviews: [
            alreadyOnBoardLable,
            loginButton],
                                              axis: .horizontal,
                                              spacing: 10)
            bottomStackView.alignment = .firstBaseline
            
            bgImage.translatesAutoresizingMaskIntoConstraints = false
            welcomeImage.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            bottomStackView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(bgImage)
            view.addSubview(welcomeImage)
            view.addSubview(stackView)
            view.addSubview(bottomStackView)
            
            NSLayoutConstraint.activate([
                welcomeImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
                welcomeImage.widthAnchor.constraint(equalToConstant: 80),
                welcomeImage.heightAnchor.constraint(equalToConstant: 80),
                welcomeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
            
              NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: welcomeImage.bottomAnchor, constant: 110),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
            ])
            
            NSLayoutConstraint.activate([
                bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
                bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
                   ])
            
            NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                   ])
        }
    }

    //// MARK: -SwiftUI
    //import SwiftUI
    //
    //struct SignUpVCProvider: PreviewProvider {
    //    static var previews: some View {
    //        ContainerView().edgesIgnoringSafeArea(.all)
    //    }
    //
    //    struct ContainerView: UIViewControllerRepresentable {
    //
    //        let signUpVC = SignUpViewController()
    //
    //        func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpVCProvider.ContainerView>) -> SignUpViewController {
    //            return signUpVC
    //        }
    //        func updateUIViewController(_ uiViewController: SignUpVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SignUpVCProvider.ContainerView>) {
    //        }
    //    }
    //}
    //
    extension UIViewController {

        func showAlert(with title: String, and message: String, completion: @escaping () -> Void = {}) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                completion()
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }

    }

