//
//  VideoService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/10/22.
//

import Alamofire
import Foundation
import SwiftUtils

class VideoService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = [
        "Cookie": LoginService().getCookiesString(),
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://www.bilibili.com/",
    ]
    init() {
        http.setHeader(headers)
    }

    func getVideoInfo(_ bvid: String, callback: @escaping (VideoInfoResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/web-interface/wbi/view?bvid=\(bvid)"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                print(result)
                do {
                    let data = try JSONDecoder().decode(VideoInfoResult.self, from: result.data(using: .utf8)!)
                    debugPrint(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getVideoInfo.catch.error")
                    fail("getVideoInfo:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getVideoInfo.http.fail")
            fail("getVideoInfo:\(error)")
        }
    }
}
