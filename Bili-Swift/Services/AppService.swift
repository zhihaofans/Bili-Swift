//
//  AppService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/17.
//

import Foundation
import SwiftUI
import SwiftUtils
import UIKit

class AppService {
    @AppStorage("open_web_in_app") private var openWebInApp = false
    func getBiliUrl(_ url: String) -> String {
        return "bilibili://browser/?url=\(url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""))"
    }

    func openAppUrl(_ urlStr: String) {
        let biliUrl = self.getBiliUrl(urlStr)
        print(biliUrl)
        Task {
            DispatchQueue.main.async {
                if biliUrl.isNotEmpty {
                    if let url = URL(string: biliUrl) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }

    func isAppIntalled() -> Bool {
        #if os(iOS)
        return AppUtil().canOpenUrl("bilibili://")
        #else
        return true
        #endif
    }

    func openUrl(appUrl: String, webUrl: String) {
        
    }
}
