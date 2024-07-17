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
    func mangaCheckin(callback: @escaping (MangaCheckinResult)->Void, fail: @escaping (String)->Void) {
        // TODO: http.post
        let headers: HTTPHeaders = [
            "Cookie": LoginService().getCookiesString(),
            "Accept": "application/json;charset=UTF-8",
        ]
        AF.request("https://manga.bilibili.com/twirp/activity.v1.Activity/ClockIn?platform=android", method: .post, headers: headers).responseString { response in
            do {
                switch response.result {
                case let .success(value):
                    print(value)
                    let result = try JSONDecoder().decode(MangaCheckinResult.self, from: value.data(using: .utf8)!)
                    debugPrint(result.code)
                    if result.code == 0 {
                        callback(result)
                    } else {
                        fail("Code \(result.code): \(result.msg)")
                    }
                case let .failure(error):
                    print(error)
                    fail(error.localizedDescription)
                }
            } catch {
                print(error)
                print("mangaCheckin.http.error")
                fail("网络请求错误:\(error.localizedDescription)")
            }
        }
    }

    func liveCheckin(callback: @escaping (LiveCheckinResult)->Void, fail: @escaping (String)->Void) {
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
