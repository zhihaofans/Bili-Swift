//
//  DynamicService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/6.
//

import Alamofire
import Foundation
import SwiftUtils

class DynamicService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = [
        "Cookie": "SESSDATA=" + LoginService().getSESSDATA(),
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
        // "Accept": "application/json;charset=UTF-8",
    ]
    init() {
        http.setHeader(headers)
    }

    func getDynamicList(callback: @escaping (DynamicListResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/all"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                // print(result)
                // print(result+"\n\n\n\n\n\n=======\n\n\n\n")
                do {
                    let data = try JSONDecoder().decode(DynamicListResult.self, from: result.data(using: .utf8)!)
                    debugPrint(data.code)
                    if data.code == 0 {
//                        debugPrint(data.data)
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getDynamicList.catch.error")
                    fail("getDynamicList:\(error.localizedDescription)")
                }
            }
        } fail: { error in
            print(error)
            print("getDynamicList.http.error")
            fail("getDynamicList:\(error)")
        }
    }
}
