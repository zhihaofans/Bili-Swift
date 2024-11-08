//
//  HistoryService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/18.
//

import Alamofire
import Foundation
import SwiftUtils

class HistoryService {
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

    func getHistory(callback: @escaping (HistoryResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/web-interface/history/cursor"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else if result.contains("Method Not Allowed") {
                fail("err:" + result)
            } else {
                print(result)
                do {
                    let result = try JSONDecoder().decode(HistoryResult.self, from: result.data(using: .utf8)!)
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
            print("getHistory.http.error")
            fail("getHistory:\(error)")
        }
    }

    func getLaterToWatch(callback: @escaping (Later2WatchResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/v2/history/toview"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                print(result)
                do {
                    let data = try JSONDecoder().decode(Later2WatchResult.self, from: result.data(using: .utf8)!)
                    debugPrint(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getLaterToWatch.catch.error")
                    fail("getLaterToWatch:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getLaterToWatch.http.error")
            fail("getLaterToWatch:\(error)")
        }
    }

    func addLaterToWatch(bvid: String, callback: @escaping (AddLater2WatchResult)->Void, fail: @escaping (String)->Void) {
        if bvid.isEmpty {
            fail("bvid is empty")
        } else {
            let parameters = ["bvid": bvid, "csrf": LoginService().getbili_jct()]
            let url = "https://api.bilibili.com/x/v2/history/toview/add"
            http.post(url, body: parameters) { result in
                if result.isEmpty {
                    fail("result.isEmpty")
                } else {
                    print(result)
                    do {
                        let data = try JSONDecoder().decode(AddLater2WatchResult.self, from: result.data(using: .utf8)!)
                        debugPrint(data.code)
                        if data.code == 0 {
                            callback(data)
                        } else {
                            fail("Code \(data.code): \(data.message)")
                        }
                    } catch {
                        print(error)
                        print("addLaterToWatch.catch.error")
                        fail("addLaterToWatch:\(error)")
                    }
                }
            } fail: { error in
                print(error)
                print("addLaterToWatch.http.error")
                fail("addLaterToWatch:\(error)")
            }
        }
    }
}
