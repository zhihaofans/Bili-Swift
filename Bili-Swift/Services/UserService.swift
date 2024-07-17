//
//  UserService.swift
//  bilibili
//
//  Created by zzh on 2024/7/17.
//
import Alamofire
import Foundation
import SwiftUtils

class UserService {
    func getUserInfo(callback: @escaping (UserInfoResult)->Void, fail: @escaping (String)->Void) {
        let headers: HTTPHeaders = [
            "Cookie": "SESSDATA=" + LoginService().getSESSDATA(),
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
            "Accept": "application/json;charset=UTF-8",
        ]
        AF.request("https://api.bilibili.com/x/web-interface/nav", headers: headers).responseString { response in
            do {
                switch response.result {
                case let .success(value):
                    debugPrint(value)
                    let result = try JSONDecoder().decode(UserInfoResult.self, from: value.data(using: .utf8)!)
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
}
