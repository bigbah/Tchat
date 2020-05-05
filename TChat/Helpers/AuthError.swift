//
//  AuthError.swift
//  TChat
//
//  Created by Ostap Andreykiv on 04.05.2020.
//  Copyright © 2020 MI Future Tech. All rights reserved.
//

import Foundation


enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case unknowError
    case serverError
    }

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Заповніть всі поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Формат пошти невідповідний", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Паролі не співпадають", comment: "")
        case .unknowError:
            return NSLocalizedString("Невідома помилка", comment: "")
        case .serverError:
            return NSLocalizedString("Помилка сервера", comment: "")
        }
    }
}
