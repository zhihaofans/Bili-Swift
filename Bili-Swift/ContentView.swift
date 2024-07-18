//
//  ContentView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/16.
//

import SwiftUI

struct ContentView: View {
    private let pageTitleList = ["main": "Bilibili", "login": "登录", "user": "个人中心"]
    @State var isLogin = false
    var body: some View {
        VStack {
            if isLogin {
                #if os(iOS)
                iosMainView()
                #else
                macMainView()
                #endif
            } else {
                LoginView()
            }
        }.onAppear {
            isLogin = LoginService().isLogin()
        }
    }
}

@available(macOS, unavailable)
struct iosMainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("签到", destination: CheckinView())
                NavigationLink("稍后再看", destination: HistoryView())
                NavigationLink("历史记录", destination: HistoryView())
            }
            .navigationTitle("哔了个哩")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserView()) {
                        // TODO: 这里跳转到个人页面或登录界面
                        Image(systemName: "person")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

@available(iOS, unavailable)
struct macMainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("签到", destination: SettingView())
                NavigationLink("稍后再看", destination: SettingView())
                NavigationLink("历史记录", destination: SettingView())
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("哔了个哩")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: SettingView()) {
                        // TODO: 这里跳转到个人页面或登录界面
                        Image(systemName: "person")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: SettingView()) {
                        // TODO: 这里跳转到个人页面或登录界面
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600) // 设置窗口的最小尺寸
    }
}

// #Preview {
//    ContentView()
// }
