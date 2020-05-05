//
//  AuthViewController.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {
    
      let bgImage = UIImageView(image: #imageLiteral(resourceName: "fdgvb"), contentMode: .scaleAspectFill)
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "bga1"), contentMode: .scaleAspectFit)
        let googleLabel = UILabel(text: "Get started with")
        let emailLabel = UILabel(text: "")
        let alreadyOnBoardLabel = UILabel(text: "Already on board?")
        
        let googleButton = UIButton(title: "Google", titleColor: #colorLiteral(red: 0.0980392918, green: 0.3725489676, blue: 0.1568627357, alpha: 1), backgroundColor: #colorLiteral(red: 0.9176471829, green: 0.9058822393, blue: 0.6705883145, alpha: 1), isShadow: true)
        let emailButton = UIButton(title: "Email", titleColor: #colorLiteral(red: 0.0980392918, green: 0.3725489676, blue: 0.1568627357, alpha: 1), backgroundColor: #colorLiteral(red: 0.9176471829, green: 0.9058822393, blue: 0.6705883145, alpha: 1), isShadow: true)
        let loginButton = UIButton(title: "Login", titleColor: #colorLiteral(red: 0.0980392918, green: 0.3725489676, blue: 0.1568627357, alpha: 1), backgroundColor: #colorLiteral(red: 0.9176471829, green: 0.9058822393, blue: 0.6705883145, alpha: 1), isShadow: true)
        
        
        let signUpVC = SignUpViewController()
        let loginVC = LoginViewController()
            
        override func viewDidLoad() {
            super.viewDidLoad()
            
            emailButton.customizeEmailButton()
            googleButton.customizeGoogleButton()
            view.backgroundColor = .mainWhite()

            setupConstrains()
            
            emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
            googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)

            signUpVC.delegate = self
            loginVC.delegate = self
            
            GIDSignIn.sharedInstance()?.delegate = self
        }
     
        @objc private func emailButtonTapped() {
            print(#function)
            present( signUpVC, animated: true, completion: nil)
        }
        
        @objc private func loginButtonTapped() {
            print(#function)
            present(loginVC, animated: true, completion: nil)
        }
        
        @objc private func googleButtonTapped() {
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.signIn()
        }
    }

    // MARK: - Setup constrains
    extension AuthViewController {
        private func setupConstrains() {
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            bgImage.translatesAutoresizingMaskIntoConstraints = false
            
            let googleView = ButtonFormView(label: googleLabel, button: googleButton)
            let emailView = ButtonFormView(label: emailLabel, button: emailButton)
            let loginView = ButtonFormView(label: alreadyOnBoardLabel, button: loginButton)
            
            let stackView = UIStackView(arrangedSubviews: [googleView, emailView], axis: .vertical, spacing: 10)
            
            let stackView1 = UIStackView(arrangedSubviews: [loginView], axis: .vertical, spacing: 10)
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView1.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(bgImage)
            view.addSubview(logoImageView)
    //        bgImage.addSubview(logoImageView)
            view.addSubview(stackView)
            view.addSubview(stackView1)
            
            NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                   ])
            
            NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 240),
            logoImageView.heightAnchor.constraint(equalToConstant: 240),
            ])

            NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
            ])
            
            NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            stackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
                   ])

        }
    }

    extension AuthViewController: AuthNavigationDelegate {
        func toLoginVC() {
            present(loginVC, animated: true, completion: nil)
        }
        
        func toSignUpVC() {
            present(signUpVC, animated: true, completion: nil)
        }
        
        
    }


    // MARK - GIDSignInDelegate
    extension AuthViewController: GIDSignInDelegate {
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            AuthService.shared.googleLogin(user: user, error: error) { (result) in
                switch result {
                    
                case .success(let user):
                    FirestoreService.shared.getUserData(user: user) { (result) in
                        switch result {
                            
                        case .success(let muser):
                            UIApplication.getTopViewController()?.showAlert(with: "Вітаю!", and: "Ви авторизовані") {
                                let mainTabBar = MainTabBarController(currentUser: muser)
                                mainTabBar.modalPresentationStyle = .fullScreen
                                UIApplication.getTopViewController()?.present(mainTabBar, animated: true, completion: nil)
                            }
                        case .failure(_):
                            UIApplication.getTopViewController()?.showAlert(with: "Вітаю!", and: "Ви зареєстровані") {
                                UIApplication.getTopViewController()?.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert(with: "Помилка", and: error.localizedDescription)
                }
            }
        }
    }

    // MARK: -SwiftUI
    import SwiftUI

    struct AuthVCProvider: PreviewProvider {
        static var previews: some View {
            ContainerView().edgesIgnoringSafeArea(.all)
        }

        struct ContainerView: UIViewControllerRepresentable {

            let viewController = AuthViewController()

            func makeUIViewController(context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) -> AuthViewController {
                return viewController
            }
            func updateUIViewController(_ uiViewController: AuthVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) {
            }
        }
    }
