//
//  ContentView.swift
//  Bili-Swift
//
//  Created by zzh on 2024/7/16.
//

import SwiftUI
import SwiftUtils

struct ContentView: View {
    private let pageTitleList = ["main": "Bilibili", "login": "登录", "user": "个人中心"]
    @State var isLogin = false
    var body: some View {
        if LoginService().isLogin() {
            #if os(iOS)
            iosMainView()
            #else
            macMainView()
            #endif
        } else {
            LoginView()
        }
    }
}

@available(macOS, unavailable)
struct iosMainView: View {
    @State private var selectedTab = 0
    var body: some View {
        switch selectedTab {
        case 1:
            HistoryView()
        case 2:
            UserView()
        default:
            NavigationView {
                List {
                    NavigationLink("签到", destination: CheckinView())
                    NavigationLink("稍后再看", destination: LaterToWatchView())
                    NavigationLink("历史记录", destination: HistoryView())
                    //NavigationLink("动态", destination: HistoryView())
                    NavigationLink("工具", destination: ToolView())
                }
                .navigationTitle(AppUtil().getAppName() /* "哔了个哩" */ )
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
        TabView(selection: $selectedTab) {
            Text("")
                .tabItem {
                    Label("主页", systemImage: "house")
                }
                .tag(0)

            Text("")
                .fixedSize(horizontal: false, vertical: true) // 纵向固定大小
                .tabItem {
                    Label("动态", systemImage: "fanblades")
                }
                .tag(1)

            Text("")
                .fixedSize(horizontal: false, vertical: true) // 纵向固定大小
                .tabItem {
                    Label("更多", systemImage: "ellipsis")
                }
                .tag(2)
        }
        .frame(maxHeight: 50) // 限制最大高度
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

#Preview {
    ContentView()
}
