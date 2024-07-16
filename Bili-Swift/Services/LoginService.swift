//
//  LoginService.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/17.
//

import Alamofire
import Foundation
import SwiftUtils

class LoginService {
    private let keychainHeader = "bilibili.login"
    func getWebLoginQrcode(callback: @escaping (LoginQrcodeData)->Void, fail: @escaping (String)->Void) {
        AF.request("https://passport.bilibili.com/x/passport-login/web/qrcode/generate").responseString { response in
            do {
                switch response.result {
                case let .success(value):
                    let loginResult = try JSONDecoder().decode(LoginQrcodeResult.self, from: value.data(using: .utf8)!)
                    debugPrint(loginResult.code)
                    if loginResult.code == 0 {
                        callback(loginResult.data)
                    } else {
                        fail(loginResult.message)
                    }
                case let .failure(error):
                    print(error)
                    fail(error.localizedDescription)
                }
            } catch {
                print("getWebLoginQrcode.http.error")
                fail("网络请求错误")
            }
        }
    }

    func checkWebLoginQrcode(qrcodeKey: String, callback: @escaping (LoginQrcodeCheckData)->Void, fail: @escaping (String)->Void) {
        AF.request("https://passport.bilibili.com/x/passport-login/web/qrcode/poll?qrcode_key=" + qrcodeKey).responseString { response in
            do {
                switch response.result {
                case let .success(value):

                    let checkResult = try JSONDecoder().decode(LoginQrcodeCheckResult.self, from: value.data(using: .utf8)!)
                    debugPrint(checkResult.code)
                    if checkResult.code == 0 {
                        if checkResult.data.code == 0 {
                            if let headerFields = response.response?.allHeaderFields as? [String: String],
                               let URL = response.request?.url
                            {
                                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                                DispatchQueue.global(qos: .userInitiated).async {
                                    // 在这里执行耗时的任务

                                    self.setLoginCookies(cookies: cookies)
                                    // 完成后，在主线程更新 UI
                                    DispatchQueue.main.async {
                                        // 更新 UI
                                        print("保存cookies")
                                    }
                                }
                            }
                            callback(checkResult.data)
                        } else {
                            fail(checkResult.data.message)
                        }
                    } else {
                        fail(checkResult.message)
                    }

                case let .failure(error):
                    print(error)
                    fail(error.localizedDescription)
                }
            } catch {
                print("getWebLoginQrcode.http.error")
                fail("网络请求错误")
            }
        }
    }

    func setLoginCookies(cookies: [HTTPCookie]) {
        for cookie in cookies {
            let saveSu = KeychainUtil().saveString(forKey: keychainHeader + ".cookie." + cookie.name.lowercased(), value: cookie.value)
            print("Cookie: \(cookie.name): \(saveSu) = \(cookie.value)")
        }
    }

    func getCookieKey(key: String)->String? {
        return KeychainUtil().getString(forKey: keychainHeader + ".cookie." + key.lowercased())
    }

    func setCookie(cookie: String)->Bool {
        return KeychainUtil().saveString(forKey: keychainHeader + ".cookie", value: cookie)
    }

    func getCookiesString()->String {
        return "bili_jct=\(getbili_jct());DedeUserID__ckMd5=\(getDedeUserID__ckMd5());SESSDATA=\(getSESSDATA());DedeUserID=\(getUid())"
    }

    func getbili_jct()->String {
        return getCookieKey(key: "bili_jct") ?? ""
    }

    func getDedeUserID__ckMd5()->String {
        return getCookieKey(key: "DedeUserID__ckMd5") ?? ""
    }

    func getSESSDATA()->String {
        return getCookieKey(key: "SESSDATA") ?? ""
    }

    func getUid()->String {
        return getCookieKey(key: "DedeUserID") ?? ""
    }

    func getSid()->String {
        return getCookieKey(key: "sid") ?? ""
    }

    func isLogin()->Bool {
        return getUid().isNotEmpty && getSESSDATA().isNotEmpty && getbili_jct().isNotEmpty
    }
}
