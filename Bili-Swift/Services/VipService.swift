//
//  VipService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/31.
//

import Alamofire
import Foundation
import SwiftUtils

class VipService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = [
        "Cookie": LoginService().getCookiesString(),
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://big.bilibili.com/mobile/bigPoint/task",
    ]
    init() {
        http.setHeader(newHeaders: headers)
    }

    func bipPointCheckin(callback: @escaping (VipCheckinResult)->Void, fail: @escaping (String)->Void) {
        // TODO: http.post
        let url = "https://api.bilibili.com/pgc/activity/score/task/sign"

        http.post(url: url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                print(result)
                do {
                    let data = try JSONDecoder().decode(VipCheckinResult.self, from: result.data(using: .utf8)!)
                    debugPrint(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("bipPointCheckin.http.error")
                    fail("bipPointCheckin:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("bipPointCheckin.http.error")
            fail("bipPointCheckin:\(error)")
        }
    }
}
