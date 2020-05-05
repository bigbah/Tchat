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
        
        let welcomeLable = UILabel(text: "Set up profile", font: .avenir26())
        
        let fullNameLable = UILabel(text: "Full name")
        let aboutMeLable = UILabel(text: "About me")
        let sexlLable = UILabel(text: "Sex")
        
        let fullNameTextField = OneLineTextField(font: .avenir20())
        let aboutMeTextField = OneLineTextField(font: .avenir20())
        let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Femail")
        
        let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .buttonDark(), cornerrRadius: 4)
        
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
            
            welcomeLable.translatesAutoresizingMaskIntoConstraints = false
            fullImageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(welcomeLable)
            view.addSubview(fullImageView)
            view.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                welcomeLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
                welcomeLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            NSLayoutConstraint.activate([
                fullImageView.topAnchor.constraint(equalTo: welcomeLable.bottomAnchor, constant: 40),
                fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            NSLayoutConstraint.activate([
                fullImageView.topAnchor.constraint(equalTo: welcomeLable.bottomAnchor, constant: 40),
                fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
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
