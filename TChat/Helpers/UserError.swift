//
//  UserError.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannotUnwrapToMuser
    case cannotGetUserInfo
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Заповніть всі поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Користувач не обрав фотографію", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Неможливо завантажити інформацію про користувача із Firebase", comment: "")
        case .cannotUnwrapToMuser:
            return NSLocalizedString("Неможливо конвертувати MUser із User", comment: "")
        }
    }
}

