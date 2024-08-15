//
//  SettingView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/16.
//

import SwiftUI
import SwiftUtils

struct SettingView: View {
    var body: some View {
        VStack {
            List {
                Section(header: Text("About")) {
                    TextItem(title: "开发者", detail: "zhihaofans")
                    TextItem(title: "Version", detail: "\(AppUtil().getAppVersion()) (\(AppUtil().getAppBuild()))" /* "0.0.1" */ )
                }
                Section(header: Text("Bilibili")) {
                    TextItem(title: "安装哔哩哔哩", detail: AppService().isAppIntalled().string(trueStr: "已安装", falseStr: "未安装"))
                }
                if LoginService().isLogin() {
                    Section(header: Text("登录数据(请不要给别人看⚠️)")) {
                        TextItem(title: "Cookies", detail: LoginService().getCookiesString())
                    }
                }
            }
            // Text("这里是设置").font(.largeTitle)
        }
        #if os(iOS)
        .navigationBarTitle("设置", displayMode: .inline)
        #else
        .navigationTitle("设置")
        #endif
    }
}

struct TextItem: View {
    var title: String
    var detail: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(detail).foregroundColor(.gray)
        }
    }
}

#Preview {
    SettingView()
}
