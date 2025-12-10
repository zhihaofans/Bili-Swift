//
//  AppService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/17.
//

import Foundation
import SwiftUI
import SwiftUtils
#if canImport(UIKit)
import UIKit
#endif

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
                        #if os(iOS)
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        #endif
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
        if appUrl.isNotEmpty {
            if self.openWebInApp, self.isAppIntalled() {
                self.openAppUrl(appUrl)
            } else {
                Task {
                    DispatchQueue.main.async {
                        if webUrl.isNotEmpty {
                            if let url = URL(string: webUrl) {
                                DispatchQueue.main.async {
                                    #if os(iOS)
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    #endif
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func checkLink(_ url: String?) -> String {
        var urlStr = url ?? ""
        if urlStr.starts(with: "//") {
            urlStr = "https:" + urlStr
        }
        if urlStr.starts(with: "http://") {
            urlStr = urlStr.replace(of: "http://", with: "https://")
        }
        return urlStr
    }
}
