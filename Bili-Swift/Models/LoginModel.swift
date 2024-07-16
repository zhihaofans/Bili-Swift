//
//  LoginModel.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/17.
//

import Foundation

struct LoginQrcodeResult: Codable {
    let code: Int
    let message: String
    let data: LoginQrcodeData
}

struct LoginQrcodeData: Codable {
    let url: String
    let qrcode_key: String
}

struct LoginQrcodeCheckResult: Codable {
    let code: Int
    let message: String
    let data: LoginQrcodeCheckData
}

struct LoginQrcodeCheckData: Codable {
    let url: String
    let refresh_token: String
    let timestamp: Int
    let code: Int
    let message: String
}
