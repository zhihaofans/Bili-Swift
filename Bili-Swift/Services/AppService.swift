//
//  AppService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/17.
//

import Foundation
import SwiftUtils

class AppService {
    func openAppUrl(url: String) async -> Bool {
        return await AppUtil().openUrl(url: <#T##URL#>)
    }

    func isAppIntalled() -> Bool {
        return AppUtil().canOpenUrl(urlString: "bilibili://")
    }
}
