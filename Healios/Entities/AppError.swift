//
//  AppError.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Foundation

enum AppError: LocalizedError {
    case none
    case error(message: String)

    var errorDescription: String? {
        switch self {
        case let .error(message):
            return message
        default:
            return ""
        }
    }
}
