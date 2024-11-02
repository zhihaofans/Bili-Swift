//
//  LiveService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/23.
//

import Alamofire
import Foundation
import SwiftUtils

class LiveService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = [
        "Cookie": LoginService().getCookiesString(),
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://www.bilibili.com/",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
    ]
    init() {
        http.setHeader(headers)
    }

    func getUserInfo(callback: @escaping (LiveUserInfoResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.live.bilibili.com/xlive/web-ucenter/user/get_user_info"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else if result.contains("Method Not Allowed") {
                fail("err:" + result)
            } else {
                print(result)
                do {
                    let result = try JSONDecoder().decode(LiveUserInfoResult.self, from: result.data(using: .utf8)!)
                    debugPrint(result)
                    if result.code == 0 {
                        callback(result)
                    } else {
                        fail(result.message)
                    }
                } catch {
                    print(error)
                    print("getHistory.catch.error")
                    fail("getHistory:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getUserInfo.http.error")
            fail("getUserInfos:\(error)")
        }
    }

    func checkIn(callback: @escaping (LiveCheckinResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.live.bilibili.com/rc/v1/Sign/doSign"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else if result.contains("Method Not Allowed") {
                fail("err:" + result)
            } else {
                print(result)
                do {
                    let result = try JSONDecoder().decode(LiveCheckinResult.self, from: result.data(using: .utf8)!)
                    debugPrint(result)
                    if result.code == 0 {
                        callback(result)
                    } else {
                        fail(result.message)
                    }
                } catch {
                    print(error)
                    print("getHistory.catch.error")
                    fail("getHistory:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("live.checkIn.http.error")
            fail("live.checkIn:\(error)")
        }
    }
}
