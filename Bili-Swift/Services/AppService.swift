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

    func openAppUrl(url: String) async -> Bool {
        let biliUrl = self.getBiliUrl(url: url)
        print(biliUrl)
        return await AppUtil().openUrl(urlString: url)
    }

    func isAppIntalled() -> Bool {
        #if os(iOS)
        return AppUtil().canOpenUrl(urlString: "bilibili://")
        #else
        return true
        #endif
    }
}
