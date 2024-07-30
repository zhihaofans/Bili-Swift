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
        "Referer": "https://big.bilibili.com/mobile/bigPoint/task",
    ]
    func getHistory(callback: @escaping (HistoryResult)->Void, fail: @escaping (String)->Void) {
        let headers: HTTPHeaders = [
            "Cookie": "SESSDATA=" + LoginService().getSESSDATA(),
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
            // "Accept": "application/json;charset=UTF-8",
        ]
        AF.request("https://api.bilibili.com/x/web-interface/history/cursor", headers: headers).responseString { response in
            do {
                switch response.result {
                case let .success(value):
                    debugPrint(value)
                    if value.contains("Method Not Allowed") {
                        fail("err:" + value)
                    } else {
                        let result = try JSONDecoder().decode(HistoryResult.self, from: value.data(using: .utf8)!)
                        debugPrint(result)
                        if result.code == 0 {
                            callback(result)
                        } else {
                            fail(result.message)
                        }
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

    func getLaterToWatch(callback: @escaping (HistoryResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/v2/history/toview"
        http.post(url: url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                print(result)
                do {
                    let data = try JSONDecoder().decode(HistoryResult.self, from: result.data(using: .utf8)!)
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
}
