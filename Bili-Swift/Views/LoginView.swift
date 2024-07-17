//
//  LoginView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/17.
//

import SwiftUI
import SwiftUtils

struct LoginView: View {
    var body: some View {
        #if os(iOS)
        iosLoginView()
        #else
        macLoginView()
        #endif
    }
}

@available(macOS, unavailable)
struct iosLoginView: View {
    // Login data
    @State private var showingAlert = false
    @State private var alertText: String = "未知错误"
    @State private var loginUrl: String = ""
    @State private var qrcodeKey: String = ""
    @State private var qrcodeText: String = "等待获取登录链接"
    private let loginService = LoginService()
    var body: some View {
        VStack {
            NavigationView {
                Text("打开哔哩哔哩扫描二维码登录")
                    .font(.largeTitle)
                    .padding()
                if loginUrl.isEmpty {
                    Text(qrcodeText)
                } else {
                    Button(action: {
                        self.loginService.checkWebLoginQrcode(qrcodeKey: self.qrcodeKey) { checkResult in
                            if checkResult.code == 0 {
                                let setSu = KeychainUtil().saveString(forKey: "bilibili.login.refresh_token", value: checkResult.refresh_token)
                                alertText = "保存登录数据" + setSu.string(trueStr: "成功", falseStr: "失败")
                                showingAlert = true
                            } else {
                                alertText = checkResult.message
                                showingAlert = true
                            }
                        } fail: { error in
                            alertText = error
                            showingAlert = true
                        }

                    }) {
                        Text("我已经登录").font(.title)
                    }
                    .alert("Error", isPresented: $showingAlert) {
                        Button("OK", action: {})
                    } message: {
                        Text(alertText)
                    }
                    .padding()
                }
            }
            .onAppear {
                if LoginService().isLogin() {
                    qrcodeText = "已登录"
                } else {
                    self.loginService.getWebLoginQrcode { loginData in
                        if !loginData.qrcode_key.isEmpty {
                            qrcodeKey = loginData.qrcode_key
                            // let qrcodeUrl = "https://passport.bilibili.com/h5-app/passport/login/scan?navhide=1&from=&qrcode_key=" + qrcodeKey
                            // self.qrCodeImage = QrcodeUtil().generateQRCode(from: loginData.url)
                        } else {
                            alertText = "空白二维码"
                            showingAlert = true
                        }
                    } fail: { errorMsg in

                        showingAlert = true
                        alertText = errorMsg
                    }
                    // self.getQrcodeData()
                }
            }
        }.navigationTitle("登入")
    }
}

@available(iOS, unavailable)
struct macLoginView: View {
    var body: some View {
        VStack {
            Text("Hello, Mac!")
        }
    }
}
