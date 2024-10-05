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
    @State private var loadLoginDataFinished = false
    @State private var loginUrl: String = ""
    @State private var qrcodeKey: String = ""
    @State private var qrcodeText: String = "等待获取登录链接"
    private let loginService = LoginService()
    var body: some View {
        VStack {
            Button(action: {
                print("loadLoginDataFinished:\(loadLoginDataFinished)")
                print("loginUrl:\(loginUrl)")
            }) {
                Text("重新加载").font(.title)
            }
            .padding()
            if !loadLoginDataFinished {
                Text(qrcodeText)
            } else {
                let qrcodeUrl = "https%3A%2F%2Fpassport.bilibili.com%2Fh5-app%2Fpassport%2Flogin%2Fscan%3Fnavhide%3D1%26from%3D%26qrcode_key%3D\(qrcodeKey)"
                if AppService().isAppIntalled() {
                    Button(action: {
                        Task {
                            // 在这里执行耗时的任务
                            let openSu = await AppUtil().openUrl(qrcodeUrl)
                            // 完成后，在主线程更新 UI
                            DispatchQueue.main.async {
                                // 更新 UI
                                print("打开app：" + openSu.string(trueStr: "Su", falseStr: "fail"))
                            }
                        }
                    }) {
                        Text("打开App登录").font(.title)
                    }
                    .padding()
                } else {
                    let qrImage = QrcodeUtil().generateQRCode(from: EncodeUtil().urlDecode( qrcodeUrl))
                    if qrImage == nil {
                        Text("请安装APP")

                    } else {
                        Image(uiImage: qrImage!).resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    }
                }
                Button(action: {
                    self.loginService.checkWebLoginQrcode(qrcodeKey: self.qrcodeKey) { checkResult in
                        if checkResult.code == 0 {
                            let setSu = KeychainUtil().saveString(forKey: "bilibili.login.refresh_token", value: checkResult.refresh_token)
                            alertText = "保存登录数据" + setSu.string(trueStr: "成功", falseStr: "失败")
                            showingAlert = true
                            if(setSu){
                                // TODO: 登录成功后操作
                            }
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

        }.onAppear {
            if LoginService().isLogin() {
                qrcodeText = "已登录"
            } else {
                self.loginService.getWebLoginQrcode { loginData in
                    print(loginData)
                    if loginData.qrcode_key.isNotEmpty {
                        qrcodeKey = loginData.qrcode_key
                        loginUrl = loginData.url
                        // self.qrCodeImage = QrcodeUtil().generateQRCode(from: loginData.url)
                        loadLoginDataFinished = true
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
