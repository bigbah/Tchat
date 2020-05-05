//
//  LoginViewController.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
     let bgImage = UIImageView(image: #imageLiteral(resourceName: "fdgvb"), contentMode: .scaleAspectFill)
    //    let welcomeLable = UILabel(text: "Welcome back!", font: .avenir26())
        let welcomeImage = UIImageView(image: #imageLiteral(resourceName: "welcome back"), contentMode: .scaleAspectFill)
        let loginWithLable = UILabel(text: "Login with:")
        let orLable = UILabel(text: "or with:")
        let emailLable = UILabel(text: "Email")
        let passwordLable = UILabel(text: "Password")
        let needAnAccountLable = UILabel(text: "Need an acount?")
        
        let googleButton = UIButton(title: "Google", titleColor: #colorLiteral(red: 0.0980392918, green: 0.3725489676, blue: 0.1568627357, alpha: 1), backgroundColor: #colorLiteral(red: 0.9176471829, green: 0.9058822393, blue: 0.6705883145, alpha: 1), isShadow: true)
        let loginButton = UIButton(title: "Login", titleColor: #colorLiteral(red: 0.0980392918, green: 0.3725489676, blue: 0.1568627357, alpha: 1), backgroundColor: #colorLiteral(red: 0.9176471829, green: 0.9058822393, blue: 0.6705883145, alpha: 1))
        
        let emailTextField = OneLineTextField(font: .avenir20())
        let passwordTextField = OneLineTextField(font: .avenir20())
        
        let signUPButton: UIButton = {
        let button = UIButton(type: .system)
            button.setTitle("Sign Up", for: .normal)
            button.setTitleColor(.buttonRed(), for: .normal)
            button.titleLabel?.font = .avenir20()
                return button
        }()
        
        weak var delegate: AuthNavigationDelegate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            googleButton.customizeGoogleButton()
            view.backgroundColor = .white
            setupConstrains()
            
            loginButton.addTarget(self, action: #selector(loginButtonButtonTapped), for: .touchUpInside)
            signUPButton.addTarget(self, action: #selector(signUPButtonTapped), for: .touchUpInside)
            googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
            
        }
        @objc private func loginButtonButtonTapped() {
            print(#function)
            AuthService.shared.login(email: emailTextField.text!,
                                     password: passwordTextField.text!) { (result) in
                                        switch result{
                                        case .success(let user):
                                            self.showAlert(with: "Вітаю!", and: "Ви авторизовані!") {
                                                FirestoreService.shared.getUserData(user: user) { (result) in
                                                    switch result {
                                                        
                                                    case .success(let muser):
                                                        let mainTabBar = MainTabBarController(currentUser: muser)
                                                        mainTabBar.modalPresentationStyle = .fullScreen
                                                        self.present(mainTabBar, animated: true, completion: nil)
                                                    case .failure(_):
                                                        self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                                                    }
                                                }
    //                                            self.present(MainTabBarController(), animated: true, completion: nil)
                                            }
                                        case .failure(let error):
                                             self.showAlert(with: "Помилка", and: error.localizedDescription)
                                        }
            }
        }
        
        @objc private func signUPButtonTapped() {
            dismiss(animated: true) {
                self.delegate?.toSignUpVC()
            }
        }
        
        @objc private func googleButtonTapped() {
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    // MARK: -Setup Constrains
    extension LoginViewController {
        
        private func setupConstrains() {
            let loginWithView = ButtonFormView(label: loginWithLable, button: googleButton)
            let emailStackView = UIStackView(arrangedSubviews: [emailLable, emailTextField],
                                                axis: .vertical,
                                                spacing: 0)
            let passwordStackView = UIStackView(arrangedSubviews: [passwordLable, passwordTextField],
                                                axis: .vertical,
                                                spacing: 0)
            loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            let stackView = UIStackView(arrangedSubviews: [
                loginWithView,
                orLable,
                emailStackView,
                passwordStackView,
                loginButton
                ],
                                        axis: .vertical,
                                        spacing: 40)
            
            signUPButton.contentHorizontalAlignment = .leading
            let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLable, signUPButton], axis:                                .horizontal,
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
                welcomeImage.widthAnchor.constraint(equalToConstant: 60),
                welcomeImage.heightAnchor.constraint(equalToConstant: 60),
                welcomeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: welcomeImage.bottomAnchor, constant: 60),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
            ])
            NSLayoutConstraint.activate([
                bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
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
    //
    //// MARK: -SwiftUI
    //import SwiftUI
    //
    //struct LoginVCProvider: PreviewProvider {
    //    static var previews: some View {
    //        ContainerView().edgesIgnoringSafeArea(.all)
    //    }
    //
    //    struct ContainerView: UIViewControllerRepresentable {
    //
    //        let loginVC = LoginViewController()
    //
    //        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) -> LoginViewController {
    //            return loginVC
    //        }
    //        func updateUIViewController(_ uiViewController: LoginVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) {
    //        }
    //    }
    //}
