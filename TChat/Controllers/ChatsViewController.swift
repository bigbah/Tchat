//
//  ChatsViewController.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatsViewController: MessagesViewController {
    
     private var messages: [MMessage] = []
        private var messageListener: ListenerRegistration?
        
        private let user: MUser
        private let chat: MChat
        
        init(user: MUser, chat: MChat) {
            self.user = user
            self.chat = chat
            super.init(nibName: nil, bundle: nil)
            
            title = chat.friendUsername
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit {
            messageListener?.remove()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            configureMessageInputBar()
            
            if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
                layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
                layout.textMessageSizeCalculator.incomingAvatarSize = .zero
                layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
                layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero

            }
            messagesCollectionView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg-1"), contentMode: .scaleAspectFill)
            messagesCollectionView.backgroundColor = #colorLiteral(red: 0.737255156, green: 0.9215685725, blue: 0.8588235974, alpha: 1)
            messageInputBar.delegate = self
            messagesCollectionView.messagesDataSource = self
            messagesCollectionView.messagesLayoutDelegate = self
            messagesCollectionView.messagesDisplayDelegate = self
            
            messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { (result) in
                switch result {
                    
                case .success(var message):
                    if let url = message.downloadURL {
                        StorageService.shared.downloadImage(url: url) { [weak self] (result) in
                            guard let self = self else { return }
                            switch result {
                                
                            case .success(let image):
                                message.image = image
                                self.insertNewMessage(message: message)
                                
                            case .failure(let error):
                                self.showAlert(with: "Помилка", and: error.localizedDescription)
                            }
                        }
                    } else {
                        self.insertNewMessage(message: message)
                    }
                case .failure(let error):
                    self.showAlert(with: "Помилка", and: error.localizedDescription)
                }
            })
        }
        
        private func insertNewMessage(message: MMessage) {
            guard !messages.contains(message) else { return }
            messages.append(message)
            messages.sort()
            let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
            let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
            
            messagesCollectionView.reloadData()
            
            if shouldScrollToBottom {
                DispatchQueue.main.async {
                    self.messagesCollectionView.scrollToBottom(animated: true)
                }
            }
        }
        
        @objc private func cameraButtonPressed() {
            let picker = UIImagePickerController()
            picker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                picker.sourceType = .photoLibrary
            }
            present(picker, animated: true, completion: nil)
        }
        
        private func sendImage(image: UIImage) {
            StorageService.shared.uploadImageMessage(photo: image, to: chat) { (result) in
                switch result {
                    
                case .success(let url):
                    var message = MMessage(user: self.user, image: image)
                    message.downloadURL = url
                    FirestoreService.shared.sendMessage(chat: self.chat, message: message) { (result) in
                        switch result {
                            
                        case .success:
                            self.messagesCollectionView.scrollToBottom()
                        case .failure(_):
                            self.showAlert(with: "Помилка", and: "Зображення не було доставлено")
                        }
                    }
                case .failure(let error):
                    self.showAlert(with: "Помилка", and: error.localizedDescription)
                }
            }
        }
    }
    // MARK: - configureMessageInputBar
        
    extension ChatsViewController {
        func configureMessageInputBar() {
            messageInputBar.isTranslucent = true
            messageInputBar.separatorLine.isHidden = true
            messageInputBar.backgroundView.backgroundColor = .mainWhite()
            messageInputBar.inputTextView.backgroundColor = .white
            messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
            messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
            messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
            messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
            messageInputBar.inputTextView.layer.borderWidth = 0.2
            messageInputBar.inputTextView.layer.cornerRadius = 18.0
            messageInputBar.inputTextView.layer.masksToBounds = true
            messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
            
            
            messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            messageInputBar.layer.shadowRadius = 5
            messageInputBar.layer.shadowOpacity = 0.3
            messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
            
            configureSendButton()
            configureCameraIcon()
        }
        
        func configureSendButton() {
            messageInputBar.sendButton.setImage(UIImage(named: "sendButton"), for: .normal)
            messageInputBar.sendButton.applyGradients(cornerRadius: 10)
            messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
            messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
            messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
            messageInputBar.middleContentViewPadding.right = -38
        }
        
        func configureCameraIcon() {
            let cameraItem = InputBarButtonItem()
    //        cameraItem.tintColor = .systemBlue
            let cameraImage = UIImage(named: "PHOTO3")!
            cameraItem.image = cameraImage
            
            cameraItem.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
            cameraItem.setSize(CGSize(width: 45, height: 45), animated: false)
            
            messageInputBar.leftStackView.alignment = .center
            messageInputBar.setLeftStackViewWidthConstant(to: 70, animated: false)
            
            messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
            
        }
    }

    extension ChatsViewController: MessagesDataSource {
        func currentSender() -> SenderType {
            return Sender(senderId: user.id, displayName: user.username)
        }
        
        func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
            return messages[indexPath.item]
        }
        
        func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
            return messages.count
        }
        
        func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
            return 1
        }
        
        func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            if indexPath.item % 4 == 0 {
                return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                                          attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                                       NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            } else {
                return nil
            }
        }
    }

    extension ChatsViewController: MessagesLayoutDelegate {
        func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
            return CGSize(width: 0, height: 8)
        }
        
        func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
            if (indexPath.item) % 4 == 0 {
                return 30
            } else {
                return 0
            }
        }
    }

    // MARK: - MessagesDisplayDelegate
    extension ChatsViewController: MessagesDisplayDelegate {
        func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return isFromCurrentSender(message: message) ?  #colorLiteral(red: 0.4470589161, green: 0.7529411912, blue: 0.5725491643, alpha: 1) : #colorLiteral(red: 0.9058825374, green: 0.9686275125, blue: 0.7607844472, alpha: 1)
        }
        
        func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
        }
        
        func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
            avatarView.isHidden = true
        }
        
        func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
            return .zero
        }
        
        func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
            return .bubbleOutline(.black)
        }
        
    }

    extension ChatsViewController: InputBarAccessoryViewDelegate {
        func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
                let message = MMessage(user: user, content: text)
                FirestoreService.shared.sendMessage(chat: chat, message: message) { (result) in
                    switch result {
                    case .success:
                        self.messagesCollectionView.scrollToBottom()
                    case .failure(let error):
                        self.showAlert(with: "Помилка!", and: error.localizedDescription)
                    }
                }
                inputBar.inputTextView.text = ""
            }
        }

    extension ChatsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            sendImage(image: image)
        }
    }


    extension UIScrollView {
        var isAtBottom: Bool {
            return contentOffset.y >= verticalOffsetForBottom
        }
        
        var verticalOffsetForBottom: CGFloat {
            let scrollViewHeight = bounds.height
            let scrollContentSizeHeight = contentSize.height
            let bottomInset = contentInset.bottom
            let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
            return scrollViewBottomOffset
        }
    }

