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
    func getUserInfo(callback: @escaping (LiveUserInfoResult)->Void, fail: @escaping (String)->Void) {
        let headers: HTTPHeaders = [
            "Cookie": LoginService().getCookiesString(),
            "Accept": "application/json;charset=UTF-8",
        ]
        AF.request("https://api.live.bilibili.com/xlive/web-ucenter/user/get_user_info", headers: headers).responseString { response in
            do {
                switch response.result {
                case let .success(value):
                    debugPrint(value)
                    let result = try JSONDecoder().decode(LiveUserInfoResult.self, from: value.data(using: .utf8)!)
                    debugPrint(result)
                    if result.code == 0 {
                        callback(result)
                    } else {
                        fail(result.message)
                    }
                case let .failure(error):
                    print(error)
                    fail(error.localizedDescription)
                }
            } catch {
                print("http.error")
                debugPrint(error)

                fail("网络请求错误:\(error.localizedDescription)")
            }
        }
    }

    func checkIn(callback: @escaping (LiveCheckinResult)->Void, fail: @escaping (String)->Void) {
        let headers: HTTPHeaders = [
            "Cookie": LoginService().getCookiesString(),
            "Accept": "application/json;charset=UTF-8",
        ]
        AF.request("https://api.live.bilibili.com/rc/v1/Sign/doSign", headers: headers).responseString { response in
            do {
                switch response.result {
                case let .success(value):
                    let result = try JSONDecoder().decode(LiveCheckinResult.self, from: value.data(using: .utf8)!)
                    debugPrint(result.code)
                    if result.code == 0 {
                        callback(result)
                    } else {
                        fail(result.message)
                    }
                case let .failure(error):
                    print(error)
                    fail(error.localizedDescription)
                }
            } catch {
                print("mangaCheckin.http.error")
                fail("网络请求错误")
            }
        }
    }
}
