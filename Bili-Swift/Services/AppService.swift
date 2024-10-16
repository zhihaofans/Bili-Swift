//
//  AppService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/17.
//

import Foundation
import SwiftUtils

class AppService {
    func getBiliUrl(url: String) -> String {
        return "bilibili://browser/?url=\(url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""))"
    }

    func openAppUrl(url: String) {
        let biliUrl = self.getBiliUrl(url: url)
        print(biliUrl)
        AppUtil().openUrl(url)
    }

    func isAppIntalled() -> Bool {
        #if os(iOS)
        return AppUtil().canOpenUrl("bilibili://")
        #else
        return true
        #endif
    }
}
