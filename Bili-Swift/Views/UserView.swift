//
//  UserView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/16.
//

import SwiftUI

struct UserView: View {
    @State var userFaceUrl = "https://i0.hdslb.com/bfs/static/jinkela/long/images/vip-login-banner.png"
    @State var userName = "未登录..."
    @State var bCoin = 0.0
    @State var Battery = 0.0
    @State var ybCoin = 0.0
    var body: some View {
        Spacer(minLength: 30)
        VStack(alignment: .center) {
            // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            AsyncImage(url: URL(string: userFaceUrl)) { image in
                image
                    .resizable() // 允许图片可调整大小
                    .scaledToFit() // 图片将等比缩放以适应框架
                    .frame(width: 120, height: 120) // 设置视图框架的大小
                    .clipShape(Circle()) // 裁剪成圆形
                    .overlay(Circle().stroke(Color.gray, lineWidth: 4)) // 可选的白色边框
            } placeholder: {
                ProgressView() // 在加载期间显示进度视图
            }
            .frame(width: 120, height: 120) // 可以重复设置，确保占位符和图片使用相同的尺寸
            // .background(Color.gray) // 背景色，以便更易看到尺寸
            Text(userName)
                .font(.largeTitle)
                .padding()
            Label(String(bCoin), systemImage: "bitcoinsign.circle").font(.title2)
            Label(String(ybCoin), systemImage: "dollarsign.circle").font(.title2)
            Label(String(Battery), systemImage: "battery.100").font(.title2)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading) // 设置对齐方式
        .onAppear {
            // TODO: 加载个人信息、头像
            Task {
                UserService().getUserInfo { result in
                    DispatchQueue.main.async {
                        // 更新 UI
                        let userData = result.data
                        if userData.isLogin {
                            userFaceUrl = userData.face!
                            userName = userData.uname!
                            bCoin = userData.getBcoin()
                            ybCoin = userData.money!
                            if userData.isVip() {
                                userName += " [VIP]"
                            }
                        } else {
                            userName = "加载失败:未登录"
                        }
                    }
                } fail: { errStr in
                    DispatchQueue.main.async {
                        userName = "加载失败:\(errStr)"
                    }
                }
            }
        }
        #if os(iOS)
        .navigationBarTitle("个人", displayMode: .inline)
        #else
        .navigationTitle("个人")
        #endif
    }
}

#Preview {
    UserView()
}
