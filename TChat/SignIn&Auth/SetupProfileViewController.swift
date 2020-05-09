//
//  SetupProfileViewController.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class  SetupProfileViewController: UIViewController {
    
        let fullImageView = AddPhotoView()
        
        let bgImage = UIImageView(image: #imageLiteral(resourceName: "bg5"), contentMode: .scaleAspectFill)
    
//        let welcomeLable = UILabel(text: "Set up profile", font: .avenir26())
        let setUpProfileImage = UIImageView(image: #imageLiteral(resourceName: "setUpProfile"), contentMode: .scaleAspectFill)
    
        let fullNameLable = UILabel(text: "Full name")
        let aboutMeLable = UILabel(text: "About me")
        let sexlLable = UILabel(text: "Sex")
        
        let fullNameTextField = OneLineTextField(font: .avenir20())
        let aboutMeTextField = OneLineTextField(font: .avenir20())
        let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Femail")
        
        let goToChatsButton = UIButton(title: "Go to chats!", titleColor: #colorLiteral(red: 0.0980392918, green: 0.3725489676, blue: 0.1568627357, alpha: 1), backgroundColor: #colorLiteral(red: 0.9176471829, green: 0.9058822393, blue: 0.6705883145, alpha: 1), cornerrRadius: 10)
        
        private let currentUser: User
        
        init(currentUser: User) {
            self.currentUser = currentUser
            super.init(nibName: nil, bundle: nil)
            
            if let username = currentUser.displayName {
                fullNameTextField.text = username
            }
            //TODO SET GOOGLE IMAGE
            if let photoURL = currentUser.photoURL {
                fullImageView.circleImageView.sd_setImage(with: photoURL, completed: nil)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            hideKeyboardWhenTappedAround()
            
            view.backgroundColor = .white
            setupConstrains()
            goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
            fullImageView.plusButton.addTarget(self, action: #selector(plussButtonTapped), for: .touchUpInside)
        }
        
        
        @objc private func plussButtonTapped() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
        
        @objc private func goToChatsButtonTapped() {
            
            FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                    email: currentUser.email!,
                                                    username: fullNameTextField.text,
                                                    avatarImage: fullImageView.circleImageView.image,
                                                    description: aboutMeTextField.text,
                                                    sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
                                                        switch result {
                                                            
                                                        case .success(let muser):
                                                            self.showAlert(with: "Вітаю!", and: "Приємного спілкування!", completion: {
                                                                let mainTabBar = MainTabBarController(currentUser: muser)
                                                                mainTabBar.modalPresentationStyle = .fullScreen
                                                                self.present(mainTabBar, animated: true, completion: nil)
                                                            })
                                                        case .failure(let error):
                                                            self.showAlert(with: "Помилка", and: error.localizedDescription)
                                                        }
            }
            
        }
    }

    // MARK -SetupConstrains
    extension SetupProfileViewController {
        private func setupConstrains() {
            
            let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLable, fullNameTextField],
                                                axis: .vertical,
                                                spacing: 0)
            
            let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLable, aboutMeTextField],
                                                axis: .vertical,
                                                spacing: 0)
            
            let sexStackView = UIStackView(arrangedSubviews: [sexlLable, sexSegmentedControl],
                                                axis: .vertical,
                                                spacing: 12)
            goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton],
                                        axis: .vertical,
                                        spacing: 40)
            
            bgImage.translatesAutoresizingMaskIntoConstraints = false
//            welcomeLable.translatesAutoresizingMaskIntoConstraints = false
            fullImageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            setUpProfileImage.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(bgImage)
//            view.addSubview(welcomeLable)
            view.addSubview(fullImageView)
            view.addSubview(stackView)
            view.addSubview(setUpProfileImage)
            
//            NSLayoutConstraint.activate([
//                welcomeLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
//                welcomeLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            ])
            NSLayoutConstraint.activate([
                fullImageView.topAnchor.constraint(equalTo: setUpProfileImage.bottomAnchor, constant: 40),
                fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                fullImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 140)
            ])
//            NSLayoutConstraint.activate([
//                fullImageView.topAnchor.constraint(equalTo: setUpProfileImage.bottomAnchor, constant: 40),
//                fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            ])
            NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
            ])
            NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            NSLayoutConstraint.activate([
            setUpProfileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            setUpProfileImage.widthAnchor.constraint(equalToConstant: 70),
            setUpProfileImage.heightAnchor.constraint(equalToConstant: 70),
            setUpProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        }
    }


    extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            fullImageView.circleImageView.image = image
        }
    }

    // MARK: -SwiftUI
    import SwiftUI

    struct SetupProfileVCProvider: PreviewProvider {
        static var previews: some View {
            ContainerView().edgesIgnoringSafeArea(.all)
        }

        struct ContainerView: UIViewControllerRepresentable {

            let setupProfileVC = SetupProfileViewController(currentUser: Auth.auth().currentUser!)

            func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
                return setupProfileVC
            }
            func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
            }
        }
    }
