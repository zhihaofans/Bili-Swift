//
//  CheckinService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/18.
//

import Alamofire
import Foundation
import SwiftUtils

class CheckinService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = [
        "Cookie": LoginService().getCookiesString(),
        "Accept": "application/json;charset=UTF-8",
    ]
    init() {
        http.setHeader(headers)
    }

    func mangaCheckin(callback: @escaping (MangaCheckinResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://manga.bilibili.com/twirp/activity.v1.Activity/ClockIn?platform=android"
        http.post(url) { value in
            if value.isEmpty {
                fail("result.isEmpty")
            } else {
                print(value)
                do {
                    let result = try JSONDecoder().decode(MangaCheckinResult.self, from: value.data(using: .utf8)!)
                    debugPrint(result.code)
                    if result.code == 0 {
                        callback(result)
                    } else {
                        fail("Code \(result.code): \(result.msg)")
                    }
                } catch {
                    print(error)
                    print("bipPointCheckin.catch.error")
                    fail("bipPointCheckin:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("mangaCheckin.http.error")
            fail("网络请求错误:\(error)")
        }
    }
}
