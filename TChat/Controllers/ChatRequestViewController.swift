//
//  ChatRequestViewController.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
  let containerView = UIView()
    
       let bgImage = UIImageView(image: #imageLiteral(resourceName: "fdgvb"), contentMode: .scaleAspectFill)
       let imageView = UIImageView(image: #imageLiteral(resourceName: "SashaGrey"), contentMode: .scaleAspectFill)
       let nameLabel = UILabel(text: "Sasha Grey", font: .systemFont(ofSize: 20, weight: .light))
       let aboutMeLabel = UILabel(text: "Look for some candies?", font: .systemFont(ofSize: 16, weight: .light))
       
       let acceptButton = UIButton(title: "ACCEPT", titleColor: #colorLiteral(red: 0.0980392918, green: 0.3725489676, blue: 0.1568627357, alpha: 1), backgroundColor: #colorLiteral(red: 0.9176471829, green: 0.9058822393, blue: 0.6705883145, alpha: 1), font: .laoSangamMN20(), isShadow: false, cornerrRadius: 10)
       let denyButton = UIButton(title: "DENY", titleColor: #colorLiteral(red: 0.8039216995, green: 0.1686273813, blue: 0.1725490391, alpha: 1), backgroundColor: .mainWhite(), font: .laoSangamMN20(), isShadow: false, cornerrRadius: 10)
       
      weak var delegate: WaitingChatsNavigation?
           
           private var chat: MChat
           
           init(chat: MChat) {
               self.chat = chat
               nameLabel.text = chat.friendUsername
               imageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL), completed: nil)
               super.init(nibName: nil, bundle: nil)
           }
           
           required init?(coder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
           
           override func viewDidLoad() {
               super.viewDidLoad()
            
            containerView.backgroundColor = .bgImage()
//               containerView.backgroundColor = .systemRed
               customizeElements()
               setupConstraints()
               
               denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
               acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
           }
           
           @objc private func denyButtonTapped() {
               self.dismiss(animated: true) {
                   self.delegate?.removeWaitingChat(chat: self.chat)
               }
           }
           
           @objc private func acceptButtonTapped() {
               self.dismiss(animated: true) {
                   self.delegate?.changeToActive(chat: self.chat)
               }
           }
           
           private func customizeElements() {
            bgImage.translatesAutoresizingMaskIntoConstraints = false
               imageView.translatesAutoresizingMaskIntoConstraints = false
               containerView.translatesAutoresizingMaskIntoConstraints = false
               nameLabel.translatesAutoresizingMaskIntoConstraints = false
               aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
               denyButton.layer.borderWidth = 1.2
               denyButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1)
               containerView.backgroundColor = .bgImage()
               containerView.layer.cornerRadius = 30
               
           }
           
           override func viewWillLayoutSubviews() {
               super.viewWillLayoutSubviews()
               self.acceptButton.applyGradients(cornerRadius: 10)
           }
           
       }

       extension ChatRequestViewController {
           private func setupConstraints() {
               
               view.addSubview(imageView)
               view.addSubview(containerView)
//            containerView.addSubview(bgImage)
               containerView.addSubview(nameLabel)
               containerView.addSubview(aboutMeLabel)
               
               
               let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 7)
               buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
               buttonsStackView.distribution = .fillEqually
               containerView.addSubview(buttonsStackView)
               
               NSLayoutConstraint.activate([
                   imageView.topAnchor.constraint(equalTo: view.topAnchor),
                   imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
               ])
               
               NSLayoutConstraint.activate([
                   containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   containerView.heightAnchor.constraint(equalToConstant: 206)
               ])
               
               NSLayoutConstraint.activate([
                   nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
                   nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
                   nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
               ])
               
               NSLayoutConstraint.activate([
                   aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                   aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
                   aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
               ])
               
               NSLayoutConstraint.activate([
                   buttonsStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
                   buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
                   buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
                   buttonsStackView.heightAnchor.constraint(equalToConstant: 56)
               ])
//               NSLayoutConstraint.activate([
//                bgImage.topAnchor.constraint(equalTo: view.topAnchor),
//                bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            ])
           }
       }


