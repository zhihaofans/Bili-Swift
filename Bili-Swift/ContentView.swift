//
//  ContentView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/16.
//

import SwiftUI

struct ContentView: View {
    private let pageTitleList = ["main": "Bilibili", "login": "登录", "user": "个人中心"]
    var body: some View {
        #if os(iOS)
        iosView()
        #else
        macView()
        #endif
    }
}

@available(macOS, unavailable)
struct iosView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("签到", destination: SettingView())
                NavigationLink("稍后再看", destination: SettingView())
                NavigationLink("历史记录", destination: SettingView())
            }
            .navigationTitle("哔了个哩")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()) {
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
struct macView: View {
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
